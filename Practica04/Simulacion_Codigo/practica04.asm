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
	ldi R20, $3F	; 0
	ldi R21, $06	; 1
	ldi R22, $5B	; 2
	ldi R23, $4F	; 3
	ldi R24, $66	; 4
	ldi R25, $6D	; 5
	ldi R26, $7D	; 6
	ldi R27, $27	; 7
	ldi R28, $7F	; 8
	ldi R29, $6F	; 9
	clr unidades
	clr decenas
	clr ZH
	
loop:
	rcall BCD_unidades
	out PORTC, aux		; Ponemos el valor de unidades en el puerto C
	rcall BCD_decenas
	out PORTA, aux		; Ponemos el valor de decenas en el puerto A
	rjmp loop
	
BCD_unidades:			; Le damos a las unidades el valor BCD
	ldi ZL, 20
	add ZL, unidades
	ld aux, Z
	ret
	
BCD_decenas:			; Le damos a las decenas el valor BCD
	ldi ZL, 20
	add ZL, decenas
	ld aux, Z
	ret
	
aumen:					; Se acciona el contador cada vez que se acabe un ciclo
	inc unidades		; Se incrementa en uno unidades
	cpi unidades, 10
	breq a_dece
	reti
	
a_dece:					; Si las unidades es igual a 10
	clr unidades		; Se pone unidades en cero	
	inc decenas			; Se incrementa en uno decenas
	cpi decenas, 10
	breq restart
	reti
	
restart:				; Si decenas es igual a diez
	clr unidades		; Se inicia el contador en cero
	clr decenas			; Es decir, se reinicia todo
	reti