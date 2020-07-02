	.include"m8535def.inc"
	.def aux = r16
	.equ step1 = 8
	.equ step2 = 4
	.equ step3 = 2
	.equ step4 = 1
	rjmp main
config_io:
	ldi aux,$0f
	out DDRC,aux
	ldi aux,0b11111011
	out DDRD,aux
	sbi PORTD,PD2
	ret
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
secuencia1:
	ldi aux,step1
	out PORTC,aux
	rcall retardo
	ldi aux,step2
	out PORTC,aux
	rcall retardo
	ldi aux,step3
	out PORTC,aux
	rcall retardo
	ldi aux,step4
	out PORTC,aux
	rcall retardo
	ret
secuencia2:
	ldi aux,step4
	out PORTC,aux
	rcall retardo
	ldi aux,step3
	out PORTC,aux
	rcall retardo
	ldi aux,step2
	out PORTC,aux
	rcall retardo
	ldi aux,step1
	out PORTC,aux
	rcall retardo
	ret
main:
	ldi aux,low(RAMEND)
	out spl,aux
	ldi aux,high(RAMEND)
	out sph,aux
	rcall config_io
case:	sbic PIND,PD2
	rcall secuencia1
	sbis PIND,PD2
	rcall secuencia2
	rjmp case
