;--------------------------------------------------------------
; @file:		P2-Display_7SEG.s
; @author:		Josue Alexander Bustamante Tepe
; @date:		14/01/2023
; @brief:		Esta archivo contiene un programa que nos muestra valores alfanuméricos(0-9 y A-F)
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
    
Condition_button:
    BTFSC PORTA,3,0		;Salta si es cero
    GOTO Numeros		;Va a Numeros
    Letras:
	;x000 1000
	Letra_A:
	  CLRF	PORTD,0		;Ponemos a 0 todo el puerto D
	  BSF	PORTD,3,0	;Configuramos las salidas para que el display de una imagen A
	  CALL	Delay_1s	;Hacemos un retardo de 1 segundo
	  BTFSC	PORTA,3,0	;Salta si es cero-->Button Press
	  GOTO Numeros		;Va hacia la etiqueta numeros
	;x000 0011
	Letra_B:
	  CLRF	PORTD,0		;Ponemos a 0 todo el puerto D
	  BSF	PORTD,0,0	;Configuramos las salidas para que el display de una imagen de b
	  BSF	PORTD,1,0
	  CALL	Delay_1s	;Hacemos un retardo de 1 segundo
	  BTFSC PORTA,3,0	;Salta si es cero-->Button Press
	  GOTO Numeros		;Va hacia la etiqueta Numeros
	;Hacemos lo mismo para todas las letras(A-F)
	;x100 0110
	Letra_C:
	  CLRF PORTD,0
	  BSF	PORTD,1,0
	  BSF	PORTD,2,0
	  BSF	PORTD,6,0
	  CALL Delay_1s
	  BTFSC	PORTA,3,0
	  GOTO Numeros
	;x100 0000
	Letra_D:
	  CLRF PORTD,0
	  BSF	PORTD,0,0
	  BSF	PORTD,5,0
	  CALL Delay_1s
	  BTFSC	 PORTA,3,0
	  GOTO Numeros
	;x000 0110
	Letra_E:
	  CLRF PORTD,0
	  BSF	PORTD,1,0
	  BSF	PORTD,2,0
	  CALL Delay_1s
	  BTFSC	PORTA,3,0
	  GOTO	Numeros
	;x000 1110
	Letra_F:
	  CLRF	PORTD,0
	  BSF	PORTD,1,0
	  BSF	PORTD,2,0
	  BSF	PORTD,3,0
	  CALL Delay_1s
	  BTFSC PORTA,3,0
	  GOTO Numeros
	  GOTO Letras	    ;Se dirige a la etiqueta Letras
	  
     Numeros:
	;x100 0000
	Numero_0:
	  CLRF PORTD,0	    ;Mandar a 0 todo el puerto d
	  BSF	PORTD,6,0   ;Configuramos las salidas para que el display nos de una imagen 0
	  CALL Delay_1s	    ;Hacemos un retardo de 1seg
	  BTFSS	PORTA,3,0   ;Salta si es 1-->button sin presionar
	  GOTO Letras	    ;Salta a la etiqueta Letras
	;x000 0110
	Numero_1:
	  SETF	PORTD,0	    ;Mandar a 1 todo el puerto d
	  BCF	PORTD,1,0   ;Configuramos las salidas para que el display nos de una imagen de 1
	  BCF	PORTD,2,0
	  CALL Delay_1s	    ;Hacemos un retardo de 1 segundo
	  BTFSS	PORTA,3,0   ;Salta si es 1-->button sin presionar
	  GOTO Letras	    ;Salta a la etiqueta Letras
	;Hacemos lo mismo para todos los numeros(1-9)
	;x010 0100
	Numero_2:
	  CLRF	PORTD,0
	  BSF	PORTD,2,0
	  BSF	PORTD,5,0
	  CALL Delay_1s
	  BTFSS	PORTA,3,0
	  GOTO Letras
	;x0110 0000
	Numero_3:
	  CLRF	PORTD,0
	  BSF	PORTD,4,0
	  BSF	PORTD,5,0
	  CALL Delay_1s
	  BTFSS	PORTA,3,0
	  GOTO Letras
	;x001 1001
	Numero_4:
	  CLRF	PORTD,0
	  BSF	PORTD,0,0
	  BSF	PORTD,3,0
	  BSF	PORTD,4,0
	  CALL Delay_1s
	  BTFSS	PORTA,3,0
	  GOTO Letras
	;x000 10010
	Numero_5:
	  CLRF	PORTD,0
	  BSF	PORTD,1,0
	  BSF	PORTD,4,0
	  CALL Delay_1s
	  BTFSS	PORTA,3,0
	  GOTO Letras
	;x000 0010
	 Numero_6:
	  CLRF	PORTD,0
	  BSF	PORTD,1,0
	  CALL Delay_1s
	  BTFSS	PORTA,3,0
	  GOTO Letras
	;x000 0111
	 Numero_7:
	  SETF	PORTD,0
	  BCF	PORTD,0,0
	  BCF	PORTD,1,0
	  BCF	PORTD,2,0
	  CALL Delay_1s
	  BTFSS	PORTA,3,0
	  GOTO Letras
	;x000 0000
	 Numero_8:
	  CLRF	PORTD,0
	  CALL Delay_1s
	  BTFSS	PORTA,3,0
	  GOTO Letras
	;x001 1000
	 Numero_9:
	  CLRF	PORTD,0
	  BSF	PORTD,3,0
	  BSF	PORTD,4,0
	  CALL Delay_1s
	  BTFSS	PORTA,3,0
	  GOTO Letras	    ;Salta a la etiqueta Letras 
	  GOTO Numeros	    ;Salta a la etiqueta Numeros
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
    BANKSEL LATA
    CLRF    LATA,1	;PORTA<7,0> = 0
    CLRF    ANSELA,1	;PORTA DIGITAL
    BSF	    TRISA,3,1	;RA3 COMO ENTRADA
    BSF	    WPUA,3,1	;ACTIVAMOS LA RESISTENCIA PULLUP DEL PIN RA3
    ;Config Port D
    BANKSEL PORTD
    SETF    PORTD,1	;PORTE<7,0> = 1
    CLRF    ANSELD,1	;PORTE DIGITAL
    CLRF    TRISD,1	;PORTE COMO SALIDA
    RETURN

END resetVect