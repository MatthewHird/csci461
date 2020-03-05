/*======================================================================
  Behaviour: 
    Preemptive RIOS

  Assumptions:
    Program is executed through the Buffalo Monitor and can access 
        the Buffalo Monitor Interrupt Jump Table
    Program uses interrupts to its advantage.


  Author: Matthew Hird
  Date: Feb 27 2020
  ======================================================================*/

// HC11 Vector, Flag, & Port Access Points
#define jump_table_toc2_opcode *(volatile unsigned char *)(0x00dc)
#define jump_table_toc2_isr *(volatile short int *)(0x00dd)

#define port_a *(volatile unsigned char *)(0x1000)
#define tcnt *(volatile short int *)(0x100e)
#define toc2 *(volatile short int *)(0x1018)
#define tctl1 *(volatile unsigned char *)(0x1020)
#define tmsk1 *(volatile unsigned char *)(0x1022)
#define tflg1 *(volatile unsigned char *)(0x1023)
#define pactl *(volatile unsigned char *)(0x1026)

#define HC11_MILLISECOND 2000
#define TOC2_MS_PER_INTERRUPT 30
#define TOC2_INTERRUPT_TIME (TOC2_MS_PER_INTERRUPT * HC11_MILLISECOND)

// HC11 Opcodes
#define OPCODE_JMP_EXTENDED (0x7e)

// OC2 Masks
#define OC2_MASK (0x40)
#define CLEAR_OC2_MASK (OC2_MASK)

// Data Direction Bits
#define DDRA7 (0x80)             // PA7

// OUTPUT
#define SEQ_TSK_OUT_BIT2 (0x40)             // PA6
#define SEQ_TSK_OUT_BIT1 (0x20)             // PA5
#define SEQ_TSK_OUT_BIT0 (0x10)             // PA4
#define SEQ_TSK_OUT_MASK (SEQ_TSK_OUT_BIT2 | SEQ_TSK_OUT_BIT1 | SEQ_TSK_OUT_BIT0)

#define SEQ_TSK_STATE_100 (SEQ_TSK_OUT_BIT2)
#define SEQ_TSK_STATE_010 (SEQ_TSK_OUT_BIT1)
#define SEQ_TSK_STATE_001 (SEQ_TSK_OUT_BIT0)

#define TOG_TSK_OUT_BIT  (0x80)             // PA7
#define TOG_TSK_OUT_MASK (TOG_TSK_OUT_BIT)
#define TOG_TSK_STATE_ON (TOG_TSK_OUT_BIT)
#define TOG_TSK_STATE_OFF (0x00)

#define NUMBER_OF_TASKS 2

#define TOGGLE_TSK_PERIOD 900
#define SEQUENCE_TSK_PERIOD 400

#define VIRTUAL_TIMER_LENGTH 12
const unsigned short virtual_timer[] = {400, 400, 100, 300, 400, 200, 200, 400, 300, 100, 400, 400};
volatile unsigned short virtual_index = 0;

#define IDLE_TASK 255                         // 0 highest priority, 255 lowest

// Readability Constants
#define TRUE 1
#define FALSE 0

typedef struct task {
    unsigned short period;                      // Rate at which the task should tick
    unsigned short elapsed_time;                // Time since task's last tick
    unsigned char state;            
    unsigned char is_running;            
    unsigned char (*tick_func)(unsigned short cur_state);    // Function to call for task's tick
} task_t;

volatile unsigned char is_tick = FALSE;

volatile unsigned short toc2_interrupt_count = 0;

volatile task_t tasks[NUMBER_OF_TASKS];

volatile unsigned char running_tasks[4] = { IDLE_TASK };    // Track running tasks-[0] always IDLE_TASK
volatile unsigned char current_task_index = 0;              // Index of highest priority task in running_tasks

// imported from buff.s (for debugging))
void wstr(char* s);
void wcrlf(void);

char t[][10] = {
    "T0\n\4",
    "T1\n\4",
    "T2\n\4",
    "T3\n\4",
    "T4\n\4",
    "T5\n\4",
    "T6\n\4",
    "T7\n\4",
    "T8\n\4",
    "T9\n\4"
};


// Forward Declarations
unsigned short toggle_tsk_tick_func(unsigned short state);
unsigned short sequence_tsk_tick_func(unsigned short state);

void toc2_isr(void) __attribute__((interrupt));


unsigned char _start() {
    __asm__("sei");
    
    volatile unsigned char i = 0;
    tasks[i].period = SEQUENCE_TSK_PERIOD;
    tasks[i].elapsed_time = SEQUENCE_TSK_PERIOD;
    tasks[i].state = SEQ_TSK_STATE_001;
    tasks[i].is_running = FALSE;
    tasks[i].tick_func = &sequence_tsk_tick_func;
    ++i;

    pactl |= DDRA7;
    tasks[i].period = TOGGLE_TSK_PERIOD;
    tasks[i].elapsed_time = TOGGLE_TSK_PERIOD;
    tasks[i].state = TOG_TSK_STATE_OFF;
    tasks[i].is_running = FALSE;
    tasks[i].tick_func = &toggle_tsk_tick_func;
    
    jump_table_toc2_opcode = OPCODE_JMP_EXTENDED;
    jump_table_toc2_isr = (short int *) toc2_isr;
    tmsk1 |= OC2_MASK; // enable toc2
    tflg1 |= CLEAR_OC2_MASK;
    toc2 = tcnt + TOC2_INTERRUPT_TIME;

    virtual_index = VIRTUAL_TIMER_LENGTH - 1;
    toc2_interrupt_count = virtual_timer[virtual_index] / TOC2_MS_PER_INTERRUPT;

    is_tick = FALSE;

    __asm__("cli");

    while(TRUE) {
        wstr(t[0]);
        
        while(!is_tick) {};
        wstr(t[1]);
        
        is_tick = FALSE;

        volatile unsigned short virtual_tick = virtual_timer[virtual_index];

        ++virtual_index;
        if (virtual_index >= VIRTUAL_TIMER_LENGTH) {
            virtual_index = 0;
        }

        // __asm__("cli");
        wstr(t[2]);
        for (i=0; i < NUMBER_OF_TASKS; ++i) {               // Heart of scheduler code
            tasks[i].elapsed_time += virtual_tick;
        wstr(t[3]);

            if (
                (tasks[i].elapsed_time >= tasks[i].period)  // Task ready
                && (running_tasks[current_task_index] > i)  // Task priority > current task priority
                && (!tasks[i].is_running)                   // Task not already running (no self-preemption)
            ) {
                __asm__("sei");                                   // Critical section
                tasks[i].elapsed_time = 0;                                  // Reset time since last tick
                tasks[i].is_running = TRUE;                                 // Mark as running
                current_task_index += 1;
                running_tasks[current_task_index] = i;        // Add to running_tasks
                __asm__("cli");                                    // End critical section
        wstr(t[4]);

                tasks[i].state = tasks[i].tick_func(tasks[i].state);    // Execute tick
        wstr(t[5]);

                __asm__("sei");                                   // Critical section
                tasks[i].is_running = FALSE;
                running_tasks[current_task_index] = IDLE_TASK;          // Remove from running_tasks
                current_task_index -= 1;
                __asm__("cli");                                    // End critical section
            }
        wstr(t[6]);

            // tasks[i].elapsed_time += virtual_tick;
        }
        wstr(t[7]);

    };

    return 0;
}

// Task: Toggle an output
unsigned short toggle_tsk_tick_func(unsigned short state) {
    switch(state) {
        case TOG_TSK_STATE_ON:
            state = TOG_TSK_STATE_OFF;
            break;
        case TOG_TSK_STATE_OFF:
            state = TOG_TSK_STATE_ON;
            break;
        default:
            state = TOG_TSK_STATE_OFF;
            break;
    }

    port_a = (port_a & (~TOG_TSK_OUT_MASK)) | state;
    return state;
}

// Task: Sequence a 1 across 3 outputs, high to low
unsigned short sequence_tsk_tick_func(unsigned short state) {
    switch(state) {
        case SEQ_TSK_STATE_100:
            state = SEQ_TSK_STATE_010;
            break;
        case SEQ_TSK_STATE_010:
            state = SEQ_TSK_STATE_001;
            break;
        case SEQ_TSK_STATE_001:
            state = SEQ_TSK_STATE_100;
            break;
        default:
            state = SEQ_TSK_STATE_100;
            break;
    }

    port_a = (port_a & (~SEQ_TSK_OUT_MASK)) | state;
    return state;
}

void toc2_isr(void) {
    if (toc2_interrupt_count < (virtual_timer[virtual_index] / TOC2_MS_PER_INTERRUPT)) {
        ++toc2_interrupt_count;
    } else {
        is_tick = TRUE;
        toc2_interrupt_count = 0;
    }

    toc2 += TOC2_INTERRUPT_TIME;
    tflg1 |= CLEAR_OC2_MASK;
    // __asm__("cli");
}