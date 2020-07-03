.include"m8535def.inc"
.def adl = r17
.def adh = r16
.def tecla = r18
rjmp  Start
.ORG $0E
RJMP CONV

Start:
	LDI R16,LOW(RAMEND) ;carga bytes bajos de la sram en r16
	OUT SPL,R16 ;coloca el r16 en sph, byte bajo de la pila
	LDI R16,HIGH(RAMEND) ;carga bytes altos de la sram en r16
	OUT SPH,R16 ;coloca el r16 en sph, byte alto de la pila
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
	rjmp  Loop ;Salta a Loop

CONV:
	IN adl,ADCL
	IN adh,ADCH
	cpi adl,$C0
	breq compara00 ;Realiza un desvio a compara00 si los registros son iguales
	cpi adl,$40
	breq compara01 ;Realiza un desvio a compara01 si los registros son iguales
	cpi adl,$80
	breq compara02 ;Realiza un desvio a compara02 si los registros son iguales
	cpi adl,$00
	breq compara03 ;Realiza un desvio a compara03 si los registros son iguales
	brne nada
	RETI

nada:
	clr tecla
	reti

compara00:
	cpi adh,$C8
	breq uno ;Realiza un desvio a uno si los registros son iguales
	cpi adh,$54
	breq mas ;Realiza un desvio a mas si los registros son iguales
	cpi adh,$B7
	breq cuatro ;Realiza un desvio a cuatro si los registros son iguales
	cpi adh,$89
	breq ocho ;Realiza un desvio a ocho si los registros son iguales
	reti

compara01:
	cpi adh,$D8
	breq on_c ;Realiza un desvio a on_c si los registros son iguales
	cpi adh,$52
	breq menos ;Realiza un desvio a menos si los registros son iguales
	cpi adh,$4F
	breq equis ;Realiza un desvio a equis si los registros son iguales 
	cpi adh,$6F
	breq nueve ;Realiza un desvio a nueve si los registros son iguales
	reti
	
compara02:
	cpi adh,$A2
	breq cero ;Realiza un desvio a cero si los registros son iguales
	cpi adh,$99
	breq dos ;Realiza un desvio a dos si los registros son iguales
	cpi adh,$79
	breq tres ;Realiza un desvio a tres si los registros son iguales
	cpi adh,$8F
	breq cinco ;Realiza un desvio a cinco si los registros son iguales
	cpi adh,$AE
	breq siete ;Realiza un desvio a siete si los registros son iguales
	cpi adh,$4D
	breq div ;Realiza un desvio a div si los registros son iguales
	reti
	
compara03:
	cpi adh,$7F
	breq igual ;Realiza un desvio a igual si los registros son iguales
	cpi adh,$73
	breq seis ;Realiza un desvio a seis si los registros son iguales
	reti

on_c:
	ldi tecla, $39 ;Guarda la C en el registro 18 para mostrar el resultado en el display
	reti

cero:
	ldi tecla, $3F ;Guarda el cero en el registro 18 para mostrar el resultado en el display
	reti

uno:
	ldi tecla, $06 ;Guarda el uno en el registro 18 para mostrar el resultado en el display
	reti
	
dos:
	ldi tecla, $5B ;Guarda el dos en el registro 18 para mostrar el resultado en el display
	reti

tres:
	ldi tecla, $4F ;Guarda el tres en el registro 18 para mostrar el resultado en el display
	reti

cuatro:
	ldi tecla, $66 ;Guarda el cuatro en el registro 18 para mostrar el resultado en el display
	reti

cinco:
	ldi tecla, $6D ;Guarda el cinco en el registro 18 para mostrar el resultado en el display
	reti

seis:
	ldi tecla, $7D ;Guarda el seis en el registro 18 para mostrar el resultado en el display
	reti

siete:
	ldi tecla, $27 ;Guarda el siete en el registro 18 para mostrar el resultado en el display
	reti

ocho:
	ldi tecla, $7f ;Guarda el ocho en el registro 18 para mostrar el resultado en el display
	reti

nueve:
	ldi tecla, $6f ;Guarda el nueve en el registro 18 para mostrar el resultado en el display
	reti

mas:
	ldi tecla, $09 ;Guarda el mas en el registro 18 para mostrar el resultado en el display
	reti

menos:
	ldi tecla, $40 ;Guarda el menos en el registro 18 para mostrar el resultado en el display
	reti

equis:
	ldi tecla, $76 ;Guarda la X en el registro 18 para mostrar el resultado en el display
	reti

div:
	ldi tecla, $52 ;Guarda el / en el registro 18 para mostrar el resultado en el display
	reti

igual:
	ldi tecla,$48 ;Guarda el = en el registro 18 para mostrar el resultado en el display
	reti
