#include "avr/io.h"
.text

.global main
main:					; etiqueta para nuestro programa principal
	ldi R16, lo8(RAMEND)		; Carga inmediatamente el byte mas bajo de la direccion final de la RAM
	ldi R17, hi8(RAMEND)		; Carga inmediatamente el byte mas alto de la direccion final de la RAM
	sts SPL, R16			; Se le asigna al puntero de pila inferior el byte de aux1
	sts SPH, R17			; Se le asigna al puntero de pila superior el byte de aux2
	ser R18			; Se le asigna el valor 0xff a aux3 (Se llena de ceros)
	out DDRA, R18			; Se le asgina a la Dirección de datos de registro A aux3 (Todos los pines del puerto A, habilitados)
	clr R18			; Se limpia el registro aux3

siguiente:
	out PORTA, R18			; Se escribe el valor del registro aux3 a los puertos de registro A
	rcall delay			; Llama a la subtunida 'delay'
	rjmp siguiente			; Salto relativo a la etiqueta siguiente (loop infinito)

delay:
	inc R18			; Incrementa el valor de aux3 en uno
	clr R17			; Limpia el registro aux2
	clr R16			; Limpia el registro aux1

loop:
	nop				; No operation. Toma un ciclo de reloj sin hacer nada
	dec  R16			; Decrementa el valor del registro aux1 en uno
	brne loop			; Verifica que la pila no sea cero
	nop				; No operation. Toma un ciclo de reloj sin hacer nada
	dec R17			; Decrementa el valor del registro R16 en dos
	brne loop			; Verifica que la pila no sea cero
	nop				; No operation. Toma un ciclo de reloj sin hacer nada
	ret				; Retorno de subrutina (regresa al llamado rcall dealy)
