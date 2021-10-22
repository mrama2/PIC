#include <xc.h>
#include <pic18f2550.h>
#include "conbits.h"
unsigned int count = 0;
void __interrupt() high_isr(void){
    INTCONbits.GIE = 0;
    
    if(PIR1bits.TMR1IF){
        if (++count == 100)
        {
            PORTA ^= 0x10; //4th pin of PORTA is toggled
            count =0;
        }
        PIR1bits.TMR1IF = 0;
    }
    
    TMR1 = 0x9E57;
    INTCONbits.GIE = 1;
}



void main(void) {
    
    TRISA &= 0xEF;   //PORTA.4 pin is made as output
   // PORTB &= 0xEF; // logical level at portb pins are made as 0
    T1CONbits.T1CKPS0 = 1; //Select the prescaler as 1:2
	TMR1 = 0x9E57;  // To make the timer overflow after 50ms @ fosc = 4MHz
    
    //RCONbits.IPEN = 1;
    PIE1bits.TMR1IE = 1;
	INTCONbits.PEIE = 1;
	INTCONbits.GIE = 1;
    
    T1CONbits.TMR1ON = 1; //Start the timer
    while(1){
        
    }
    
}
