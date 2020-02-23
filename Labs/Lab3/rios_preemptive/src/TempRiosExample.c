typedef struct task {
    unsigned long period;       // Rate at which the task should tick
    unsigned long elapsedTime;  // Time since task's last tick
    void (*TickFct)(void);      // Function to call for task's tick
} task;

task tasks[2];
const unsigned char tasksNum = 2;
const unsigned long tasksPeriodGCD = 200;   //Timer tick rate
const unsigned long periodToggle = 1000;
const unsigned long periodSequence = 200;

void TickFct_Toggle(void);
void TickFct_Sequence(void);

unsigned char processingRdyTasks = 0;

const unsigned long idleTask = 255;             // 0 highest priority, 255 lowest
unsigned char runningTasks[4] = { idleTask };   // Track running tasks-[0] always idleTask
unsigned char currentTask = 0;                  // Index of highest priority task in runningTasks


void TimerSet(int milliseconds) {
    TCNT1 = 0;
    OCR1A = milliseconds*1000;
}

void TimerOn() {
    TCCR1B = (1<<WGM12)|(1<<CS11); //Clear timer on compare. Prescaler = 8
    TIMSK1 = (1<<OCIE1A); //Enables compare match interrupt
    SREG |= 0x80; //Enable global interrupts
}

void TimerOff() {
    TIMSK1 &= (0xFF ^ (1<<OCIE1A)); //Disable compare match interrupt
}

void TimerISR() {
    unsigned char i;
    SaveContext();                                  //save temporary registers, if necessary
    for (i=0; i < tasksNum; ++i) {                  // Heart of scheduler code
        if ( 
            (tasks[i].elapsedTime >= tasks[i].period)   // Task ready
            && (runningTasks[currentTask] > i)          // Task priority > current task priority
            && (!tasks[i].running)                      // Task not already running (no self-preemption)
        ) {
            DisableInterrupts();                                // Critical section
            tasks[i].elapsedTime = 0;                           // Reset time since last tick
            tasks[i].running = 1;                               // Mark as running
            currentTask += 1;
            runningTasks[currentTask] = i;                      // Add to runningTasks
            EnableInterrupts();                                 // End critical section
            
            tasks[i].state = tasks[i].TickFct(tasks[i].state);  // Execute tick
            
            DisableInterrupts();                                // Critical section
            tasks[i].running = 0;
            runningTasks[currentTask] = idleTask;               // Remove from runningTasks
            currentTask -= 1;
            EnableInterrupts();                                 // End critical section
        }
        tasks[i].elapsedTime += tasksPeriodGCD;
    }
    RestoreContext();                               //restore temporary registers, if necessary
} 

void main() {
    // Priority assigned to lower position tasks in array
    unsigned char i=0;
    tasks[i].period = periodSequence;
    tasks[i].elapsedTime = tasks[i].period;
    tasks[i].TickFct = &TickFct_Sequence;
    ++i;
    tasks[i].period = periodToggle;
    tasks[i].elapsedTime = tasks[i].period;
    tasks[i].TickFct = &TickFct_Toggle;
    TimerSet(tasksPeriodGCD);
    TimerOn();
    while(1) { Sleep(); }
}

// Task: Toggle an output
void TickFct_Toggle() {
    static unsigned char init = 1;
    if (init) { // Initialization behavior
        B0 = 0;
        init = 0;
    } else {    // Normal behavior
        B0 = !B0;
    }
}

// Task: Sequence a 1 across 3 outputs
void TickFct_Sequence() {
    static unsigned char init = 1;
    unsigned char tmp = 0;
    if (init) { // Initialization behavior
        B2 = 1; B3 = 0; B4 = 0;
        init = 0;
    } else {    // Normal behavior
        tmp = B4; B4 = B3; B3 = B2; B2 = tmp;
    }
} 