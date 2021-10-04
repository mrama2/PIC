;PIC Assembly language program to add data
;store SUM in file register location 10H

; PIC18F4520 Configuration Bit Settings

; Assembly source line config statements
#include <xc.inc>
    
; CONFIG1H
  CONFIG  OSC = HSPLL           ; Oscillator Selection bits (HS oscillator, PLL enabled (Clock Frequency = 4 x FOSC1))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

 
          A1 equ 0x20

 PSECT res_vect, class=code, reloc=2
 res_vect:
    goto main

PSECT code 
main:
 	CLRF STATUS,a
	 

	  CLRW        ;  w =0
	  CLRF TMR1L,a ; TMR1L = 0
	  CLRF TMR1H,a ; TMR1H = 0
	  CLRF INTCON,a ; INTCON = 0
	  CLRF PORTC,a   ; PORTC =0
	  MOVLW 0X64   ; w = 100
	  MOVWF A1,a   ; A1 = 100
	  CLRF TRISC,a  ; TRIC = 0 All PORTC pins as output
	  BSF INTCON,7,a           ;SET GLOBAL INTERRUPTS ENABLE BIT
          
	  BSF INTCON,6,a		 ;SET PERIPHERAL INTERRUPT ENABLE BIT
	  BSF PIE1,0,a		 ;TIMER1 INTERRUPT ENABLE BIT
	
	  MOVLW 0X10       ; w = 0x10
	  MOVWF T1CON,a            ;1:2 PRESCALE VALUE, TIMER1 OSC ENABLED

	  MOVLW 0X57             ;TIMER1 IS LOADED WITH A VALUE 
	  MOVWF TMR1L,a	 	 ;EQUIVALENT TO 50ms DELAY
	  MOVLW 0X9E		 
	  MOVWF TMR1H,a

	  BSF T1CON,0,a  ; Turn on timer
LOOP:	  GOTO LOOP

    
         PSECT isr_vect, class=code, reloc=2
	 goto isr
	 ORG 0x200
	 isr:
          BCF PIR1,0,a	; CLEAR THE INTERRUPT FLAG
	  DECFSZ A1,1
	  GOTO EXIT
	  BTG PORTC, 4, a
	  MOVLW 0x64
	  MOVWF A1,a
	  	  
EXIT: MOVLW 0X57
	  MOVWF TMR1L,a           ;RELOAD THE TIMER
	  MOVLW 0X9E
	  MOVWF TMR1H,a
	  RETFIE

    END res_vect



