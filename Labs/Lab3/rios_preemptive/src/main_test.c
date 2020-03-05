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

#define breakpoint1 *(volatile unsigned char *)(0x4000)

#define HC11_MILLISECOND 2000
#define TOC2_MS_PER_INTERRUPT 30
#define TOC2_INTERRUPT_TIME (TOC2_MS_PER_INTERRUPT * HC11_MILLISECOND)

// HC11 Opcodes
#define OPCODE_JMP_EXTENDED (0x7e)

// OC2 Masks
#define OC2_MASK (0x40)
#define CLEAR_OC2_MASK (OC2_MASK)

// Data Direction Bits
#define DDRA3 (0x08)             // PA3
#define DDRA7 (0x80)             // PA7

// OUTPUT
#define SEQ_TSK_OUT_BIT2 (0x40)             // PA6
#define SEQ_TSK_OUT_BIT1 (0x20)             // PA5
#define SEQ_TSK_OUT_BIT0 (0x10)             // PA4
#define SEQ_TSK_OUT_MASK (SEQ_TSK_OUT_BIT2 | SEQ_TSK_OUT_BIT1 | SEQ_TSK_OUT_BIT0)

#define SEQ_TSK_STATE_100 (SEQ_TSK_OUT_BIT2)
#define SEQ_TSK_STATE_010 (SEQ_TSK_OUT_BIT1)
#define SEQ_TSK_STATE_001 (SEQ_TSK_OUT_BIT0)

#define TOG_TSK_OUT_BIT (0x80)              // PA7
#define TOG_TSK_OUT_MASK (TOG_TSK_OUT_BIT)
#define TOG_TSK_STATE_ON (TOG_TSK_OUT_BIT)
#define TOG_TSK_STATE_OFF (0x00)

#define NUMBER_OF_TASKS 2
#define TASK_PERIOD_GCD 200                   // Timer tick rate in ms

#define TOGGLE_TSK_PERIOD 1000
#define SEQUENCE_TSK_PERIOD 200

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

volatile unsigned short toc2_interrupt_count = 0;

volatile task_t tasks[NUMBER_OF_TASKS];

volatile unsigned char running_tasks[4] = { IDLE_TASK };    // Track running tasks-[0] always IDLE_TASK
volatile unsigned char current_task_index = 0;              // Index of highest priority task in running_tasks

// imported from buff.s (for debugging))
void wstr(char* s);
void wcrlf(void);

// for debugging
void reverse(char* in_str, unsigned short length); 
void itoa(unsigned short num, char* out_str); 
void print_int(unsigned short print_number);

char t0[10] = "Test0\n\4";
char t1[10] = "Test1\n\4";
char t2[10] = "Test2\n\4";
char t3[10] = "Test3\n\4";
char t4[10] = "Test4\n\4";
char t5[10] = "Test5\n\4";
char t6[10] = "Test6\n\4";
char t7[10] = "Test7\n\4";
char t8[10] = "Test8\n\4";
char t9[10] = "Test9\n\4";
char rev_temp[100];

volatile unsigned char my_wait = 0;
volatile unsigned short my_count = 0;


// Forward Declarations
void init_tasks(void);
unsigned short toggle_tsk_tick_func(unsigned short state);
unsigned short sequence_tsk_tick_func(unsigned short state);

void enable_interrupts(void);
void disable_interrupts(void);
void enable_toc2(void);
void disable_toc2(void);
void init_toc2(void);
void update_toc2(void);
void start_task(task_t task, unsigned char task_number);
void end_task(task_t task);
void toc2_isr(void) __attribute__((interrupt));


unsigned char _start() {
    disable_interrupts();
    init_toc2();
    enable_interrupts();

    while(TRUE){

        wstr(t0);
        while(my_wait == 0) {};
        wstr(t1);

    }
        disable_interrupts();


    return 0;
}

void enable_interrupts(void) { __asm__("cli"); }
void disable_interrupts(void) { __asm__("sei"); }

void enable_toc2(void) { tmsk1 |= OC2_MASK; }
void disable_toc2(void) { tmsk1 |= !OC2_MASK; }

void init_toc2(void) {
    jump_table_toc2_opcode = OPCODE_JMP_EXTENDED;
    jump_table_toc2_isr = (short int *) toc2_isr;
    enable_toc2();
    tflg1 |= CLEAR_OC2_MASK;
    toc2 = tcnt + TOC2_INTERRUPT_TIME;
}

void update_toc2(void) {
    toc2 += TOC2_INTERRUPT_TIME;
    tflg1 |= CLEAR_OC2_MASK;
}

void toc2_isr(void) {
    if (my_wait != 0) {
        my_wait = 2;
        tflg1 |= CLEAR_OC2_MASK;
        tmsk1 |= !OC2_MASK;
        disable_interrupts();
    } else {
        if (my_count < 100) {
            ++my_count;
        } else {
            my_count = 0;

            wstr(t2);

            if (my_wait == 0) {
                my_wait = 1;
                update_toc2();
                enable_interrupts();
                while (my_wait == 1) {}
                wstr(t3);
            }

            tflg1 |= CLEAR_OC2_MASK;
            disable_interrupts();
        }
    }

}
