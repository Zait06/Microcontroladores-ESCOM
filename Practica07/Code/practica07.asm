.def adl = r17
.def adh = r16
.def tecla = r18
rjmp  Start
.ORG $0E
RJMP CONV

Start:
	LDI R16,LOW(RAMEND)
	OUT SPL,R16
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16
	SER R16
	OUT DDRD,R16
	OUT DDRB,R16
	OUT DDRC,R16
	LDI R16,$ED ; 1110 1101
	OUT ADCSRA,R16
	ldi r16,$20; 0010 0000, con $00 la alineacion es a la izquierda
	out ADMUX,r16
	clr tecla
	SEI

Loop:
	OUT PORTD,adl
	OUT PORTB,adh
	out portc,tecla
	rjmp  Loop

CONV:
	IN adl,ADCL
	IN adh,ADCH
	cpi adl,$C0
	breq compara00
	cpi adl,$40
	breq compara01
	cpi adl,$80
	breq compara02
	cpi adl,$00
	breq compara03
	brne nada
	RETI

nada:
	clr tecla
	reti

compara00:
	cpi adh,$C8
	breq uno
	cpi adh,$54
	breq mas
	cpi adh,$B7
	breq cuatro
	cpi adh,$89
	breq ocho
	reti

compara01:
	cpi adh,$D8
	breq on_c
	cpi adh,$52
	breq menos
	cpi adh,$4F
	breq equis
	cpi adh,$6F
	breq nueve
	reti
	
compara02:
	cpi adh,$A2
	breq cero
	cpi adh,$99
	breq dos
	cpi adh,$79
	breq tres
	cpi adh,$8F
	breq cinco
	cpi adh,$AE
	breq siete
	cpi adh,$4D
	breq div
	reti
	
compara03:
	cpi adh,$7F
	breq igual
	cpi adh,$73
	breq seis
	reti

on_c:
	ldi tecla, $39
	reti

cero:
	ldi tecla, $3F
	reti

uno:
	ldi tecla, $06
	reti
	
dos:
	ldi tecla, $5B
	reti

tres:
	ldi tecla, $4F
	reti

cuatro:
	ldi tecla, $66
	reti

cinco:
	ldi tecla, $6D
	reti

seis:
	ldi tecla, $7D
	reti

siete:
	ldi tecla, $27
	reti

ocho:
	ldi tecla, $7f
	reti

nueve:
	ldi tecla, $6f
	reti

mas:
	ldi tecla, $09
	reti

menos:
	ldi tecla, $40
	reti

equis:
	ldi tecla, $76
	reti

div:
	ldi tecla, $52
	reti

igual:
	ldi tecla,$48
	reti