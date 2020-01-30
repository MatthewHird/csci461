/*======================================================================
  Behaviour: 
    Traffic Light Controller Cycle Executive Program follows the
        guidelines specified in the document for CSCI355 lab9 (PDF): 

    http://csciun1.mala.bc.ca:8080/~pwalsh/teaching/355/newLabs/Lab9.pdf

    +=================================+
    | State to Traffic Light Encoding |
    +=================================+
    |  State  |  Highway  | Farm-road |
    |   OUT   |   Light   |   Light   |
    |---------|-----------|-----------|
    |   00    |   Green   |    Red    |
    |   01    |   Yellow  |    Red    |
    |   11    |    Red    |   Green   |
    |   10    |    Red    |   Yellow  |
    +---------------------------------+

  Assumptions:
    Program is executed through the Buffalo Monitor and can access 
        the Buffalo Monitor Interrupt Jump Table
    Program uses interrupts to its advantage.

  Pins: 
    Program is designed to use the following I/O pins on the HC11: 
      IN:
        PA1 -> Farm-road Car Sensor
      OUT:
        PA6 -> State(High Bit)
        PA5 -> State(Low Bit)

  Author: Matthew Hird
  Date: Jan 29 2019
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

// HC11 Opcodes
#define OPCODE_JMP_EXTENDED 0x7e

// OC2 Masks
#define OC2_MASK (0x40)         // 01000000
#define CLEAR_OC2_MASK (OC2_MASK)

// OUTPUT
#define LIGHT_OUT_BIT1 (0x40)   // P6
#define LIGHT_OUT_BIT0 (0x20)   // P5
#define LIGHT_OUT_MASK (LIGHT_OUT_BIT1 | LIGHT_OUT_BIT0)

// INPUT
#define CAR_IN_BIT (0x02)       // P1
#define CAR_IN_MASK (CAR_IN_BIT)

// FSM States
#define HG_STATE (0x00)         // 00000000
#define HY_STATE (0x20)         // 00100000
#define FG_STATE (0x60)         // 01100000
#define FY_STATE (0x40)         // 01000000

// Readability Constants
#define TRUE 1
#define FALSE 0

// 20000 ticks per frame -> 100 frames per second
#define FRAME_LENGTH 20000
// 1 frame per cycle -> 100 cycles per second
#define CYCLE_LENGTH = 1 * FRAME_LENGTH; 

#define STO_MAX 300      // 300 cycles = 3 seconds 
#define LTO_MAX 1000     // 1000 cycles = 10 seconds

volatile unsigned short sto_count = 0;
volatile unsigned short lto_count = 0;

volatile unsigned char state = HG_STATE;
volatile unsigned char is_car = FALSE;
volatile unsigned char is_wait = TRUE;
volatile unsigned char sto_flag = FALSE;
volatile unsigned char lto_flag = FALSE;

// imported from buff.s
void wstr(char* s);
void wcrlf(void);

// local function forward declarations
void frame_sync_isr(void) __attribute__((interrupt));
void read_car_in(void);
void update_sto(void);
void update_lto(void);
void update_state(void);
void set_light_out(void);


unsigned char _start() {
    __asm__("sei");
    
    jump_table_toc2_opcode = OPCODE_JMP_EXTENDED;
    jump_table_toc2_isr = (short int *) frame_sync_isr;
    tmsk1 |= OC2_MASK;
    tflg1 |= CLEAR_OC2_MASK;
    toc2 = tcnt + FRAME_LENGTH;

    __asm__("cli");
    set_light_out();

    while (TRUE) {
        is_wait = TRUE;
      
        while (is_wait == TRUE) {};

        read_car_in();
        update_sto();
        update_lto();
        update_state();
        set_light_out();
    }

    return 0;
}

void frame_sync_isr(void) {
    tflg1 |= CLEAR_OC2_MASK;
    toc2 += FRAME_LENGTH;
    is_wait = FALSE;
}

void read_car_in(void) {
    is_car = (port_a & CAR_IN_MASK) ? TRUE : FALSE;
}

void update_sto(void) {
    if (sto_count < STO_MAX) {
        sto_count++;
    }
    sto_flag = (sto_count == STO_MAX) ? TRUE : FALSE;
}

void update_lto(void) {
    if (lto_count < LTO_MAX) {
        lto_count++;
    }
    lto_flag = (lto_count == LTO_MAX) ? TRUE : FALSE;
}

void update_state(void) {
    switch(state) {
        case HG_STATE:
            if ((is_car == TRUE) && (lto_flag == TRUE)) {
                state = HY_STATE;
                sto_count = 0;
                lto_count = 0;
            } else {
                state = HG_STATE;
            }
            break;
        case HY_STATE:
            if (sto_flag == TRUE) {
                state = FG_STATE;
                sto_count = 0;
                lto_count = 0;
            } else {
                state = HY_STATE;
            }
            break;
        case FG_STATE:
            if (((is_car == FALSE) && (sto_flag == TRUE)) || (lto_flag == TRUE)) {
                state = FY_STATE;
                sto_count = 0;
                lto_count = 0;
            }
            break;
        case FY_STATE:
            if (sto_flag == TRUE) {
                state = HG_STATE;
                sto_count = 0;
                lto_count = 0;
            }
            break;
    }
}

void set_light_out(void) {
    port_a = (port_a & (~LIGHT_OUT_MASK)) | state;
}
