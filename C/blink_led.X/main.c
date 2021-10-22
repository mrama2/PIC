/*
 * File:   main.c
 * Author: SRM
 *
 * Created on 3 August, 2021, 3:25 PM
 */


#include "pic18f2550.h"
#include "conbits.h"
void main(void) {
    TRISA = 0x00;  //POrtb as output 
    while(1)
    {
        PORTA = 0x00;
        __delay_ms(1000);
        PORTA = 0x7F;
        __delay_ms(1000);
    }
      
    return;
}
