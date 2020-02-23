/*======================================================================
  Behaviour: 
    Preemptive RIOS

  Assumptions:
    Program is executed through the Buffalo Monitor and can access 
        the Buffalo Monitor Interrupt Jump Table
    Program uses interrupts to its advantage.


  Author: Matthew Hird
  Date: Feb 22 2020
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

#define HC11_MILLISECOND 2000
#define TOC2_MS_PER_INTERRUPT 10
#define TOC2_INTERRUPT_TIME (TOC2_MS_PER_INTERRUPT * HC11_MILLISECOND)

// HC11 Opcodes
#define OPCODE_JMP_EXTENDED (0x7e)

// OC2 Masks
#define OC2_MASK (0x40)
#define CLEAR_OC2_MASK (OC2_MASK)

// OUTPUT
#define SEQ_TSK_OUT_BIT2 (0x40)             // P6
#define SEQ_TSK_OUT_BIT1 (0x20)             // P5
#define SEQ_TSK_OUT_BIT0 (0x10)             // P4
#define SEQ_TSK_OUT_MASK (SEQ_TSK_OUT_BIT2 | SEQ_TSK_OUT_BIT1 | SEQ_TSK_OUT_BIT0)

#define SEQ_TSK_STATE_100 (SEQ_TSK_OUT_BIT2)
#define SEQ_TSK_STATE_010 (SEQ_TSK_OUT_BIT1)
#define SEQ_TSK_STATE_001 (SEQ_TSK_OUT_BIT0)

#define TOG_TSK_OUT_BIT  (0x08)             // P3
#define TOG_TSK_OUT_MASK (TOG_TSK_OUT_BIT)
#define TOG_TSK_STATE_ON (TOG_TSK_OUT_BIT)
#define TOG_TSK_STATE_OFF (0x00)

#define NUMBER_OF_TASKS = 2
#define TASK_PERIOD_GCD = 200                   // Timer tick rate in ms

#define TOGGLE_TSK_PERIOD = 1000
#define SEQUENCE_TSK_PERIOD = 200

#define IDLE_TASK = 255                         // 0 highest priority, 255 lowest

typedef struct task {
    unsigned short period;                      // Rate at which the task should tick
    unsigned short elapsed_time;                // Time since task's last tick
    unsigned char state;            
    unsigned char is_running;            
    void (*tick_func)(unsigned short state);    // Function to call for task's tick
} task_t;

volatile unsigned short toc2_interrupt_count = 0;

volatile task_t tasks[NUMBER_OF_TASKS];

volatile unsigned char running_tasks[4] = { IDLE_TASK };    // Track running tasks-[0] always IDLE_TASK
volatile unsigned char current_task_index = 0;              // Index of highest priority task in running_tasks

void init_tasks(void);
void toggle_tsk_tick_func(unsigned short state);
void sequence_tsk_tick_func(unsigned short state);

void enable_interrupts(void);
void disable_interrupts(void);
void enable_toc2(void);
void disable_toc2(void);
void init_toc2(void);
void update_toc2(void);
void start_task(task_t task);
void end_task(task_t task);
void toc2_isr(void) __attribute__((interrupt));


unsigned char _start() {
    disable_interrupts();
    init_tasks()
    init_toc2();
    enable_interrupts();

    while(TRUE) {};

    return 0;
}

void init_tasks(void) {
    // Priority assigned to lower position tasks in array
    unsigned char i=0;
    tasks[i].period = SEQUENCE_TSK_PERIOD;
    tasks[i].elapsed_time = SEQUENCE_TSK_PERIOD;
    tasks[i].state = SEQ_TSK_STATE_001;
    tasks[i].is_running = FALSE;
    tasks[i].tick_func = &sequence_tsk_tick_func;
    ++i;
    tasks[i].period = TOGGLE_TSK_PERIOD;
    tasks[i].elapsed_time = TOGGLE_TSK_PERIOD;
    tasks[i].state = TOG_TSK_STATE_OFF;
    tasks[i].is_running = FALSE;
    tasks[i].tick_func = &toggle_tsk_tick_func;
} 

// Task: Toggle an output
void toggle_tsk_tick_func(unsigned short state) {
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
void sequence_tsk_tick_func(unsigned short state) {
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

void enable_interrupts(void) { __asm__("cli"); }
void disable_interrupts(void) { __asm__("sei"); }

void enable_toc2(void) { tmsk1 |= OC2_MASK; }
void disable_toc2(void) { tmsk1 |= !OC2_MASK; }

void init_toc2(void) {
    jump_table_toc2_opcode = OPCODE_JMP_EXTENDED;
    jump_table_toc2_isr = (short int *) toc2_isr;
    enable_toc2()
    tflg1 |= CLEAR_OC2_MASK;
    toc2 = tcnt + TOC2_INTERRUPT_TIME;
}

void update_toc2(void) {
    toc2 += TOC2_INTERRUPT_TIME;
    tflg1 |= CLEAR_OC2_MASK;
}

void start_task(task_t task) {
    disable_interrupts();                                   // Critical section
    task.elapsed_time = 0;                                  // Reset time since last tick
    task.is_running = TRUE;                                 // Mark as running
    current_task_index += 1;
    running_tasks[current_task_index] = i;                  // Add to running_tasks
    enable_interrupts();                                    // End critical section
}

void end_task(task_t task) {
    disable_interrupts();                                   // Critical section
    task.is_running = FALSE;
    running_tasks[current_task_index] = IDLE_TASK;          // Remove from running_tasks
    current_task_index -= 1;
    enable_interrupts();                                    // End critical section
}

void toc2_isr(void) {
    unsigned char i;
    // save_context();                            //save temporary registers, if necessary
    
    unsigned char is_tick = FALSE;
    if (toc2_interrupt_count < (TASK_PERIOD_GCD * TOC2_MS_PER_INTERRUPT)) {
        ++toc2_interrupt_count;
    } else {
        is_tick = TRUE;
        toc2_interrupt_count = 0;
    }

    update_toc2();
    enable_interrupts();

    if (is_tick) {
        for (i=0; i < NUMBER_OF_TASKS; ++i) {               // Heart of scheduler code
            if (
                (tasks[i].elapsed_time >= tasks[i].period)  // Task ready
                && (running_tasks[current_task_index] > i)  // Task priority > current task priority
                && (!tasks[i].is_running)                   // Task not already running (no self-preemption)
            ) {
                start_task(tasks[i]);

                tasks[i].state = tasks[i].tick_func(tasks[i].state);    // Execute tick

                end_task(tasks[i]);
            }
            tasks[i].elapsed_time += TASK_PERIOD_GCD;
        }
    }

    // restore_context();                         //restore temporary registers, if necessary
}
