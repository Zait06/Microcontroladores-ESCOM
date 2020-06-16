.include "m8535def.inc"
.def aux=R16
.def unidades=R17
.def decenas=R18

rjmp main
.org $009			; Salto al registro $009
rjmp aumen

main:
	ldi aux, low(RAMEND)
	out spl, aux
	ldi aux, high(RAMEND)
	out sph, aux			; Inicializacion de la pila
	ser aux
	out DDRC, aux
	out DDRA, aux
	ldi aux, 5
	out tccr0, aux
	ldi aux, 1
	out timsk, aux
	sei
	
load:
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
	clr unidades
	clr decenas
	clr ZH
	
loop:
	rcall BCD_unidades
	out PORTC, aux
	rcall BCD_decenas
	out PORTA, aux
	rjmp loop
	
BCD_unidades:
	ldi ZL, 20
	add ZL, unidades
	ld aux, Z
	ret
	
BCD_decenas:
	ldi ZL, 20
	add ZL, decenas
	ld aux, Z
	ret
	
aumen:
	inc unidades
	cpi unidades, 10
	breq a_dece
	reti
	
a_dece:
	clr unidades
	inc decenas
	cpi decenas, 10
	breq restart
	reti
	
restart:
	clr unidades
	clr decenas
	reti
	
maxi:
	ldi decenas, 9
	reti
