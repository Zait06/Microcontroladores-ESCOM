
.include "m8535def.inc"
.def aux=r16
.def cont=r17
.def aux2=r18

rjmp main			; el programa brinca a esta instruccion cuando ocurre reset
rjmp incre			; Registro $001 (INT0) tiene rutina 'incre'
rjmp decre			; Registro $002 (INT1) tiene rutina 'decre'
.org $009			; Salto al registro $009
rjmp sube			; Se agrega la rutina para cada pulso
.org $012			; Salto al registro $012
rjmp pause			; Se agrega la rutina 'pause'

main:
	ldi aux, low(RAMEND)
	out spl, aux
	ldi aux, high(RAMEND)
	out sph, aux	; Estas 4 instr. inicializan el SP
	ser aux
	out ddra, aux	; Activamos los puetos 'A' para la salida
	; out ddrc, aux
	out portd, aux	; Activamos los puertos 'D' como entrada
	out portb, aux	; Activamos los puertos 'B' como entrada
	ldi aux,$0E
	out MCUCR,aux	; Se establece INT0 para flanco de bajada e INT1 para flanco de subida
	ldi aux,$40
	out MCUCSR,aux	; Se establece INT2
	ldi aux,$E0
	out GICR,aux	; Se habilitan INT0 INT1 INT2
	ldi aux, 5
	out tccr0, aux
	ldi aux, 1
	out timsk, aux
	sei

load:				; Valores del 0 al 9 en BCD
	ldi R20, $3F
	ldi R21, $06
	ldi R22, $5B
	ldi R23, $4F
	ldi R24, $66
	ldi R25, $6D
	ldi R26, $7D
	ldi R27, $27
	ldi R28, $7F
	ldi R29, $6F 
	ldi aux2, $01	; Inicializa en 1 aux2
	clr ZH
	clr cont		; Contador en cero

loop:
	rcall comparar00
	rcall comparar01
	rcall comparar02
	out PORTA, aux		; Se muestra el valor del contador en BCD
	; out PORTC, cont
	rjmp loop

sube:
	add cont,aux2
	cpi cont, 10
	breq a_dece00	; Si el contador es igual a 10, salta a a_dec00
	cpi cont, $ff
	breq a_dece01	; Si el contador es igual a -1, salta a a_dec01
	reti

a_dece00:
	clr cont		; Pone en cero el contador
	reti

a_dece01:
	ldi cont,$09	; Pone en 9 el contador
	reti

incre:				; Si INT0 es activado
	ldi aux2, $01	; aux2 toma el valor de 1
	reti

decre:				; Si INT1 es activado
	ldi aux2, $ff	; aux2 toma el valor de -1
	reti

pause:				; Si INT2 es activado
	ldi aux2, $00	; aux2 toma el valor de 0
	reti

comparar00:
	cpi aux2, $01	; Si aux2 es 1
	breq BCD		; salta  a BCD
	ret

comparar01:
	cpi aux2, $ff	; Si aux2 es -1
	breq BCD		; salta a BCD
	ret

comparar02:
	cpi aux2, $00	; Si aux2 es 0
	ld aux, Z		; Se matiene aux con el valor Z
	ret

BCD:				; Pone el contador de binario a 7 segmentos
	ldi ZL, 20
	add ZL, cont
	ld aux, Z
	ret