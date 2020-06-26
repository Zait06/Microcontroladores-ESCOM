	.include"m8535def.inc"
	.def aux = r16
	.def col = r17
	
.macro ldb		; Macro lbd
	; @0 registro bajo
	; @1 valor a guardar
	ldi aux,@1	; Se carga el valor ingresado @1 en aux
	mov @0,aux	; Se mueve el valor de aux en el registro @0
.endm

.macro mensaje	; Macro mensaje
	; @0,@1,@2,@3,@4 valores hexadecimales o enteros
	; Se llaman a la macro lbd para guardar los valores
	; en un registro en especial
	ldb r4,@0
	ldb r3,@1
	ldb r2,@2 
	ldb r1,@3
	ldb r0,@4
.endm

.macro deco		; Macro deco
	; @0 Es un registro
	push zh		; Se agrega zh en el pila
	push zl		; Se agrega zl en la pila
	ldi ZH, high(tabla<<1)	; Se inicializa apuntador ZH
    ldi ZL, low(tabla<<1)	; Se inizaliza apuntador ZL
    add zl,@0	; suma a ZL el registro entrante
    lpm aux,Z   ; Se carga contante del programa
    mov @0,aux	; Se mueve el valor de aux al registro entrante
	pop zl		; Se saca de la pila ZL
	pop zh		; Se saca de la pila ZH
.endm

.macro inidet	; Macro ident
	;@0 valor hexadecimal
	push aux	; Se agrega aux a la pila
	push col	; Se agrega col en la pila
	in aux,timsk	; aux contendrá el valor del reistro timsk
	ldi col,@0	; Se carga el valor entrante a col
	eor aux,col	; Se aplica la or exclusiva en aux y col y se guarda en aux
	out timsk,aux	; pone el valor de aux en el registro timsk
	pop col		; Se saca col de la pila
	pop aux		; Se saca aux d ela pila
.endm

reset:
	rjmp main ; vector de reset
	rjmp stst0;verctor INT0
	rjmp stst1;verctor INT1
	.org OVF2addr;$004
	rjmp cuenta1; vector timer2
	.org OVF1addr;$008
	rjmp cuenta0;vector timer1
	rjmp barre;vector timer0
	.org INT2addr;$012
	rjmp stst2;vector INT2

main:
	ldi aux,low(ramend)
	out spl,aux
	ldi aux,high(ramend)
	out sph,aux			; Se inicializa la pila del programa
	rcall config_io		; Se llama a config_io
	rcall texto0		; Se llama a texto0
	clr zh				; Se limpia el apuntador zh
	clr zl				; Se limpia el apuntador zl
	ldi col,1			; Se carga a col en 1
	out portc,col		; Se muestra col en el puerto C
	ld aux,z			; Se carga a aux el valor de Z
	out porta,aux		; Se muestra en el puerto A el valor de aux

uno:nop			; No hay operacion, un ciclo de reloj menos
	nop			; No hay operacion, un ciclo de reloj menos
	rjmp uno	; Salta a la uno

config_io:
	ser aux			; Se le signa el valor FF
	out ddra,aux	; Se inicia como puerto de salida A
	out portb,aux	; Se inicia como puerto de entrada B
	out ddrc,aux	; Se inicia como puerto de salida C
	out portd,aux	; Se inicia como puerto de entrada D
	ldi aux,1		; Se carga uno en aux
	out tccr0,aux	; Se selecciona el reloj sin preescala
	ldi aux,2		; Se carga dos en aux
	out tccr1b,aux	; Se selecciona el reloj/128 de preescala de contador uno
	ldi aux,$01; 0000 0001
	out timsk,aux; toie0
	ldi aux,5		; Se carga aux con 5
	out tccr2,aux	; Se selecciona el reloj/128 de preescalade 8 bits
	ldi aux,$0a; 0000 1010
	out mcucr,aux	; Se activan las interrupciones INT1
	ldi aux,$e0; 1110 0000
	out gicr,aux	; Se habilitan las interrupciones
	sei				; pone vantera i en uno
	ldi r22,16		; Se carga el valor 16 al registro
	ret				; Regresa a donde fue llamada

texto0:
	mensaje 0,0,$40,0,0	; Se llama a la macro mesaje
	; Mueve el valor de los registros bajos a uno alto
	mov r18,r0
	mov r19,r1
	mov r20,r3
	mov r21,r4
	rcall conv	; Llama a conv
	ret

cuenta0:		; Cuando se desborde el timer1
	inc r18		; Incrementa en uno el registro
	cpi r18,10	; Compara si el registro es igual a diez
	brne sal0	; Si el registro no es igual a diez, salta a sal0
	clr r18		; Se limpia el registro 
	inc r19		; Incrementa en uno el registro
	cpi r19,10	; Compara si el registro es igual a 10
	brne sal0	; Si no es igual a 10, salta a sal0
	clr r19		; Se limpia el registro

sal0:			; Si el registro no es igual a 10, entonces
	mov r0,r18	; Mueve el valor de r18 a r0
	mov r1,r19	; Mueve el valor de r16 a r1
	deco r0		; Llama a la macro deco
	deco r1		; Llama a la macro deco
	reti		; Regresa a donde fue llamado

cuenta1:		; Cuando se desborde el timer0
	dec r22		; Decrementa en uno el registro
	brne otro	; Si la bandera Z es igual a 0, salta a otro
	ldi r22,16	; Se carga el valor 16 al registro
	inc r20		; Se incrementa en uno el registro
	cpi r20,10	; Compara si r20 es igual a 10
	brne sal1	; Si no son iguales, salta a sal1
	clr r20		; Se limpia el registro
	inc r21		; Se incrementa en uno el registro
	cpi r21,10	; Compara si el resigro es igual a 10
	brne sal1	; Si no son iguales, entonces salta a sal1
	clr r21		; Se limpia el registro r21

sal1:			; Si el registro es igual a 10
	mov r3,r20	; Se mueve el r20 a r3
	mov r4,r21	; Se mueve el r21 a r4
	deco r3		; Llama a la macro deco
	deco r4		; Llama a la macro deco
otro:
	reti	; Regresa a donde fue llamado

conv:
	; Para los registros r0 a r4 se decodifica para poderlos postrar en los display
	deco r0
	deco r1
	deco r3
	deco r4  
	ret

barre:				; Cuando se desborde con counter0
	out porta,zh	; Se carga el valor de ZH al puerto A
	inc zl			; Se incrementa en uno ZL
	lsl col			; Recorre un bit a la izquierda del registro
	cpi col,$20		; Compara si col es igual a 20 hexadecimal
	brne dos		; Si no es igual entonces salta a dos (z = 0)
	ldi col,1		; Carga en el registro el valor de uno
	clr zl			; Se limpia ZL

dos:				; Si el registro es igual a 32 decimal
	out portc,col	; Muestra en el puerto C el valor de col
	ld aux,z		; Carga en aux el valor del registro Z
	out porta,aux	; Muestra en el puerto A el valor de aux
	reti			; Regresa a donde fue llamado

stst0:
	inidet $04		; Se llama a la macro inidet
	reti

stst1:
	inidet $40		; Se llama a la macro inidet
	reti

stst2:
	inidet $44		; Se llama a la macro inidet
	reti

tabla:
.db $3f,$06,$5b,$4f,$66,$6d,$7d,$27,$7f,$6f


