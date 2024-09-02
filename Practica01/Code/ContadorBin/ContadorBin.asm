.include "m8535def.inc"
.def aux1 = r16				; alias aux1 al registro 16
.def aux2 = r17				; alias aux1 al registro 17
.def aux3 = r18				; alias aux1 al registro 18

main:					; etiqueta para nuestro programa principal
	ldi aux1,low(RAMEND)		; Carga inmediatamente el byte mas bajo de la direccion final de la RAM
	ldi aux2,high(RAMEND)		; Carga inmediatamente el byte mas alto de la direccion final de la RAM
	out spl,aux1			; Se le asigna al puntero de pila inferior el byte de aux1
	out sph,aux2			; Se le asigna al puntero de pila superior el byte de aux2
	ser aux3			; Se le asigna el valor 0xff a aux3 (Se llena de ceros)
	out ddra,aux3			; Se le asgina a la Dirección de datos de registro A aux3 (Todos los pines del puerto A, habilitados)
	clr aux3			; Se limpia el registro aux3

siguiente:
	out porta,aux3			; Se escribe el valor del registro aux3 a los puertos de registro A
	rcall delay			; Llama a la subtunida 'delay'
	rjmp siguiente			; Salto relativo a la etiqueta siguiente (loop infinito)

delay:
	inc aux3			; Incrementa el valor de aux3 en uno
	clr aux2			; Limpia el registro aux2
	clr aux1			; Limpia el registro aux1

loop:
	nop				; No operation. Toma un ciclo de reloj sin hacer nada
	dec  aux1			; Decrementa el valor del registro aux1 en uno
	brne loop			; Verifica que la pila no sea cero
	nop				; No operation. Toma un ciclo de reloj sin hacer nada
	dec aux2			; Decrementa el valor del registro aux1 en dos
	brne loop			; Verifica que la pila no sea cero
	nop				; No operation. Toma un ciclo de reloj sin hacer nada
	ret				; Retorno de subrutina (regresa al llamado rcall dealy)
