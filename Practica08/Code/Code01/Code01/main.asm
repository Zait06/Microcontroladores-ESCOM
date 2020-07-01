.include"m8535def.inc"
.def aux=r16
.def aux2=r17
.def aux3=r18
.def cont = r19
.def contWing = r20
.def unid = r21
.def dece = r22

rjmp main
.org $004
rjmp tono ; timer2 ovf
.org $008
rjmp seg5 ; timer1 ovf
rjmp cuenta ; timer0 ovf

main:
	ldi aux,low(RAMEND)
	out spl,aux
	ldi aux,high(RAMEND)
	out sph,aux
	ser aux
	out ddrb,aux
	out ddra,aux
	out ddrc,aux
	ldi aux,6
	out tccr0,aux
	ldi aux,1
	out timsk,aux
	clr cont
	sei

loop:
	nop
	nop
	out porta,cont
	rjmp loop

tono:
	ldi aux,115
	out tcnt2,aux
	ser aux
	in r17,pinb
	eor r17,aux
	out portb,r17
	reti

seg5:
	ldi aux2,1
	out timsk,aux2
	reti

cuenta:
	ldi aux3,55
	out tcnt0,aux3
	ldi aux3,$b5
	out tcnt1l,aux3
	ldi aux3,$b3
	out tcnt1h,aux3
	ldi aux3,$45;     01000101
	out timsk,aux3
	reti