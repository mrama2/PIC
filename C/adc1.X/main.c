#include <xc.h>
#include <stdio.h>
#include <pic18f2550.h>
#include "conbits.h"
unsigned int count = 0;


void main(void) {
    
    unsigned int AdcResult = 0;
    TRISB  = 0x00;   //PORTB pins are made as output
    TRISC  = 0x00;   //PORTC pins are made as output
    TRISA &= 0xEF;
    TRISA |= 0x01;
    ADCON2 = 0xBE;   // 
    ADCON1 = 0x0E;   // AN0 as analog pin
    ADCON0 = 0x01;  //ADC Module ON
    while(1)
    {
        ADCON0 |=0x02; //Start the ADC conversion
        while((ADCON0&0x02)== 0);
        PORTB = ADRESL;
        PORTC = ADRESH;
        AdcResult = ADRESL + (ADRESH << 8);
        if(AdcResult < 5)
        {
            PORTA |= 0x10;
            __delay_ms(1000);
            PORTA &= 0xEF;
            __delay_ms(1000);
        }        
    }    
}
