;--------------------------------------------------------------
; @file:		P1-Corrimiento_Leds.s
; @author:		Josue Alexander Bustamante Tepe
; @date:		14/01/2023
; @brief:		Esta archivo contiene un corrimiento de leds
;------------------------------------------------------------------

    PROCESSOR 18F57Q84
    
#include "Bit_config.inc" /config statements should precede project file includes./
#include "Retardos1.inc"
#include <xc.inc>

PSECT resetVect,class=CODE, reloc=2
resetVect:
    goto Main
PSECT CODE
Main:
    CALL    Config_OSC
    CALL    Config_Port
    NOP
Condicion_Button:
    
    BANKSEL PORTA		;seleccionamos el puerto donde esta el boton del pic
    BTFSC   PORTA,3,1		;salta si es cero-->boton presionado
    GOTO    Corrimiento_off	;si no esta presionado va a corrimiento off
    Corrimiento_general:
    ;corrimiento impar tiene un retardo de 250ms
    Corrimiento_impar:
	BANKSEL PORTE		    ;seleccionamos el banco del puerto E
	BSF	PORTE,0,1	    ;prendemos el led que identifica que es un corrimiento impar
	BANKSEL PORTC		    ;seleccionamos el puerto C que es donde se da el corrimiento
	CLRF	PORTC,1		    ;Mandamos a 0 las salidas del puerto c -->todos los led off
	BSF	PORTC,0,1	    ;Mandamos a 1 el bit 0 del puerto c-->led del bit 0 del puerto c on
	CALL	Delay_250ms,1	    ;Hacemos un retardo de 250 ms
	BTFSS PORTA,3,1		    ;Salta si esta en 1-->no presionamos el led
	CALL	Led_Stop	    ;Va a la subrutina Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_250ms,1	    ;Retardo de 250ms
	BTFSS PORTA,3,1		    ;Salta si esta en 1-->no presionamos el led
	CALL	Led_Stop	    ;Va a la subrutina Led_Stop
	;Hacemos lo mismo 8 veces
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
 	CALL Delay_250ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_250ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_250ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_250ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_250ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_250ms,1
	BCF	PORTE,0,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
    ;corrimiento par tiene un retardo de 500ms
    Corrimiento_par:
	BANKSEL PORTE		    ;Seleccionamos el banco del Puerto E
	BSF	PORTE,1,1	    ;Prendemos el led que identifica que es un corrimiento par
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_500ms,1	    ;Hacemos un retardo de 500ms
	BTFSS PORTA,3,1		    ;Salta si es 1-->no presionamos el button
	CALL	Led_Stop	    ;Va a la subrutina Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_500ms,1	    ;Hacemos un retardo de 500ms
	BTFSS PORTA,3,1		    ;Salta si es 1-->no presionamos el button
	CALL	Led_Stop	    ;Va a la subrutina Led_Stop
	;Repetimos lo mismo 8 veces
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_500ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_500ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_500ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_500ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_500ms,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	RLNCF   PORTC,1,1	    ;mover un bit a la izquierda
	CALL Delay_500ms,1
	BCF PORTE,1,1
	BTFSS PORTA,3,1
	CALL	Led_Stop
	GOTO Corrimiento_impar	    ;Regresa al corrimiento impar
Led_Stop:
	CALL Delay_500ms,1	    ;Hacemos un retardo de 500ms
	XD:
	BANKSEL PORTA		    ;Seleccionamos el banco del puerto a
	MOVLW 2			    ;Cargamos el w con valor de 2
	;Buton press-->f=0        0000 0000
	;Buton no press_-->f=8    0000 1000
	CPFSGT	PORTA,1		    ;Comparamos el PORTA y el w-->Salta si f es mayor
	RETURN			    ;Retorna y sigue con el corrimiento
	GOTO XD			    ;Vuelve a XD a buscar si el button esta presionado
Corrimiento_off:			;leds off
	CLRF	PORTC			;Todo el puerto c-->0
	GOTO	Condicion_Button	;Regresa a condicion_Button para ver si hubo algun cambio
	
Config_OSC:
    ;configuración del Oscilador interno a una frecuencia de 4Mhz
    BANKSEL OSCCON1
    MOVLW 0x60	;seleccionamos el bloque del oscilador interno con un div:1
    MOVWF OSCCON1
    MOVLW 0X02	;seleccionamos a una frecuencia de 4Mhz
    MOVWF OSCFRQ
    RETURN
 
Config_Port:	;PORT-LAT-ANSEL-TRIS LED:RF3,  BUTTON:RA3
    ;Config Button
    BANKSEL PORTA
    CLRF    PORTA,1	;PORTA<7,0> = 0
    CLRF    ANSELA,1	;PORTA DIGITAL
    BSF	    TRISA,3,1	;RA3 COMO ENTRADA
    BSF	    WPUA,3,1	;ACTIVAMOS LA RESISTENCIA PULLUP DEL PIN RA3
    ;Config Port E
    BANKSEL PORTE
    CLRF    PORTE,1	;PORTE<7,0> = 0
    CLRF    ANSELE,1	;PORTE DIGITAL
    BCF	    TRISE,0,1	;PORTE<0> COMO SALIDA
    BCF	    TRISE,1,1	;PORTE<1> COMO SALIDA
    ;Config Port C
    BANKSEL PORTC
    CLRF    PORTC,1	;PORTC<7,0>=0
    CLRF    ANSELC,1	;PORTC DIGITAL
    CLRF    TRISC,1	;PORTC COMO SALIDA
    RETURN

END resetVect