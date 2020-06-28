.include "m8535def.inc"
.def aux = r28
.def dato = r29

reset:
	ser aux
	out DDRA, aux	; Se habilita puerto A como salida
	out DDRC, aux	; Se habilita puerto C como salida
	out portb, aux	; Se habilita puerto B como entrada

load:
	ldi aux, $3f
	mov r12,aux ;0
	ldi aux, 6
	mov r13,aux ;1
	ldi aux, $5b
	mov r14,aux ;2
	ldi aux, $4f 
	mov r15,aux	;3
	ldi r16,$66 ;4
	ldi r17,$6d ;5
	ldi r18,$7d ;6
	ldi r19,$27 ;7
	ldi r20,$7f ;8
	ldi r21,$6f ;9
	ldi r22,$77 ;A
	ldi r23,$7c ;B
	ldi r24,$39 ;C
	ldi r25,$7e ;D
	ldi r26,$79 ;E
	ldi r27,$71 ;F

otro: 
	ldi ZL,12			; Se carga a la parte de la pila ZL el valor 12
	in dato, pinb		; Se carga a dato la entrada del puerto B
	andi dato,$0f		; Se hace una and a de (registro & constante) 
	out porta, dato		; Se pone a la salida dato
	add ZL,dato			; Se suma el valor de dato a ZL
	ld dato,Z			; Se carga a dato el valor de Z
	out portc,dato		; Se pone en la salida C el valor de Z (BCD)
	rjmp otro
