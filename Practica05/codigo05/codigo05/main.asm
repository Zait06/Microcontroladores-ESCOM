
.include "m8535def.inc"
.def aux=r16
.def cont=r17
.def aux2=r18

rjmp main			; el programa brinca a esta instruccion cuando ocurre reset
rjmp incre
rjmp decre
.org $009
rjmp sube
.org $012
rjmp pause

main:
	ldi aux, low(RAMEND)
	out spl, aux
	ldi aux, high(RAMEND)
	out sph, aux	; estas 4 instr. inicializan el SP
	ser aux
	out ddra, aux
	out ddrc, aux
	out portd,aux
	ldi aux,$0E
	out MCUCR,aux	; se establece INT0 para flanco de bajada e INT1 para flanco de subida
	ldi aux,$40
	out MCUCSR,aux	; se establece INT2
	ldi aux,$E0
	out GICR,aux	; se habilitan INT0 INT1 INT2
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
	ldi aux2, $01
	clr ZH
	clr cont	

loop:
	;ldi ZL, 20
	rcall comparar00
	rcall comparar01
	rcall comparar02
	;add ZL, cont
	;ld aux, Z
	out PORTA, aux
	out PORTC, cont
	rjmp loop

sube:				; Si llega a 10 el contador, este se inica de nuevo en cero
	add cont,aux2
	cpi cont, 10
	breq a_dece00
	cpi cont, $ff
	breq a_dece01
	reti

a_dece00:
	clr cont
	reti

a_dece01:
	ldi cont,$09
	reti

incre:
	ldi aux2, $01
	reti

decre:
	ldi aux2, $ff
	reti

pause:
	ldi aux2, $00
	reti

comparar00:
	cpi aux2, $01
	breq suma
	ret

suma:
	ldi ZL, 20
	add ZL, cont
	ld aux, Z
	ret

comparar01:
	cpi aux2, $ff
	breq resta
	ret

resta:
	ldi ZL, 29
	sub ZL, cont
	ld aux, Z
	ret

comparar02:
	cpi aux2, $00
	breq suma
	ret