.include"m8535def.inc"
.def aux = r16
.equ step1 = 8	; 00001000
.equ step2 = 4	; 00000100
.equ step3 = 2	; 00000010
.equ step4 = 1	; 00000001

rjmp config_io		; El programa brinca a esta instruccion cuando ocurre reset
rjmp secuencia2		; Registro $001 (INT0) tiene rutina 'secuencia2	'

config_io:
	ldi aux, $0F
	out DDRC, aux	; Activamos los puertos 'A' para la salida (solo 4 puertos)
	ldi aux, $04
	out PORTD,aux	; Activamos los puertos 'D' para la ENTRADA
	ldi aux,$02
	out MCUCR,aux	; Se establece INT0 para flanco de bajada
	ldi aux,$40
	out GICR,aux	; Se habilitan INT0
	sei

main:
	rcall secuencia1	; Ciclo infinito
	rjmp main

secuencia1:				; Secuencia uno
	ldi aux,step1		; Valor de 1
	out PORTC,aux		; Muestra a la salida
	rcall retardo		; Retardo

	ldi aux,step2		; Valor de 2
	out PORTC,aux		; Muestra a la salida
	rcall retardo		; Retardo

	ldi aux,step3		; Valor de 4
	out PORTC,aux		; Muestra a la salida
	rcall retardo		; Retardo

	ldi aux,step4		; Valor de 8
	out PORTC,aux		; Muestra a la salida
	rcall retardo		; Retardo
	ret

secuencia2:				; Secuencia 2
	ldi aux,step4		; Valor de 8
	out PORTC,aux		; Muestra a la salida
	rcall retardo		; Retardo

	ldi aux,step3		; Valor de 4
	out PORTC,aux		; Muestra a la salida
	rcall retardo		; Retardo

	ldi aux,step2		; Valor de 2
	out PORTC,aux		; Muestra a la salida
	rcall retardo		; Retardo

	ldi aux,step1		; Valor de 1
	out PORTC,aux		; Muestra a la salida
	rcall retardo		; Retardo
	reti

retardo:
;    delay loop generator 
;     250000 cycles:
; ----------------------------- 
; delaying 249999 cycles:
          ldi  R17, $A7
WGLOOP0:  ldi  R18, $02
WGLOOP1:  ldi  R19, $F8
WGLOOP2:  dec  R19
          brne WGLOOP2
          dec  R18
          brne WGLOOP1
          dec  R17
          brne WGLOOP0
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 

	ret
