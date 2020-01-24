/*==================================================
  Behaviour: Traffic Light Controller Cycle Executive
    Program follows guidelines specified in CSCI355
    lab9 at: 
        http://csciun1.mala.bc.ca:8080/~pwalsh/
            teaching/355/newLabs/Lab9.pdf


  Assumptions:
    Program uses interrupts to its advantage.

  Pins: Program is designed to use following pins on
    HC11: PA1, PA5, PA6

  Author: Ezra MacDonald Dec 3 2018
  ==================================================*/

// HC11 Vector, Flag, & Port Access Points
#define PV0C2 *(volatile unsigned char *)(0x10dc)
#define PV0C2JMP *(volatile short int *)(0x10dd)
#define tmsk1 *(volatile unsigned char *)(0x1022)
#define porta *(volatile unsigned char *)(0x1000)
#define toc2 *(volatile short int *)(0x1018)
#define tcnt *(volatile short int *)(0x100e)
#define tctl1 *(volatile unsigned char *)(0x1020)
#define tflg1 *(volatile unsigned char *)(0x1023)

// Values to clear HC11 flags
#define oc2 0x40
#define toggle 0x40
#define clear 0x40

// Timing Value
#define TBASE 20000

#define TICK 1
#define LMASK 0x9f 
#define HG 0x00 // 0000 0000
#define HY 0x20 // 0010 0000
#define FG 0x60 // 0110 0000
#define FY 0x40 // 0100 0000
#define TRUE 1
#define FALSE 0

/* State */
const unsigned short STOMAX = 300;
const unsigned short LTOMAX = 1000;
volatile unsigned short stoCount = 0;
volatile unsigned short ltoCount = 0;

volatile unsigned char carOn = FALSE;
volatile unsigned char state = 0;
volatile unsigned char checkStatus = 0;
volatile unsigned char stoFlag = FALSE;
volatile unsigned char ltoFlag = FALSE;

void interruptFunc(void) __attribute__((interrupt));
void getCar(void);
void shortTimer(void);
void longTimer(void);
void fsm(void);
void setLights(void);


unsigned char _start() {
  // enable interrupts
  __asm__("sei");
  PV0C2 = 0x7e;
  PV0C2JMP = (short int *) interruptFunc;
  tmsk1 |= oc2;
  tflg1 |= clear;
  toc2 = tcnt + TBASE;

	__asm__("cli");
    setLights();

	while (1) {
        checkStatus = FALSE;
        while (checkStatus == FALSE) {};
		getCar();
		shortTimer();
		longTimer();
		fsm();
		setLights();
	}

	return 0;
}

void interruptFunc(void) {
	tflg1 |= clear;
	toc2 = toc2 + TBASE;
	checkStatus = TRUE;
}

void getCar(void) {
	if (porta & 0x02)
		carOn = TRUE;
	else
		carOn = FALSE;
}

void shortTimer(void) {
   if (stoCount < STOMAX) {
      stoCount = stoCount + 1;
   }
   if (stoCount == STOMAX) {
      stoFlag = TRUE;
   } else {
      stoFlag = FALSE;
   }
}

void longTimer(void) {
   if (ltoCount < LTOMAX) {
      ltoCount = ltoCount + 1;
   }
   if (ltoCount == LTOMAX) {
      ltoFlag = TRUE;
   } else {
      ltoFlag = FALSE;
   }
}

void fsm(void) {
	switch(state) {
		case HG:
			if ((carOn == TRUE) && (ltoFlag == TRUE)) {
				state = HY;
				stoCount = 0;
				ltoCount = 0;
			} else {
				state = HG;
			}
         	break;
      	case HY:
      		if (stoFlag == TRUE) {
      			state = FG;
      			stoCount = 0;
      			ltoCount = 0;
      		} else {
      			state = HY;
      		}
         	break;
      	case FG:
         	if (((carOn == FALSE) && (stoFlag == TRUE)) || (ltoFlag == TRUE)) {
            	state = FY;
        		stoCount = 0;
        		ltoCount = 0;
         	}
       	 	break;
      	case FY:
         	if (stoFlag == TRUE) {
            	state = HG;
                stoCount = 0;
                ltoCount = 0;
     		}
         	break;
   		}
}

void setLights(void) {
    porta = (porta & LMASK) | state;
}
