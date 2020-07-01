.include "m8535def.inc"
.def aux1 = r16
.def aux2 = r17
.def aux3 = r18

main:
	ldi aux1,low(RAMEND)
	ldi aux2,high(RAMEND)
	out spl,aux1
	out sph,aux2
	ser aux3
	out ddra,aux3
	clr aux3

siguiente:
	out porta,aux3
	rcall delay
	rjmp siguiente

delay:
	inc aux3
	clr aux2
	clr aux1

loop:
	nop
	dec  aux1
	brne loop
	nop
	dec aux2
	brne loop
	nop
	ret
