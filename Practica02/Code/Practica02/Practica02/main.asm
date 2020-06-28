reset:
	ser R16 ;Se asigna al R16 $ff (R16 <- $ff)
	out DDRA,R16 ;Se habilita como salida El puerto A y se asigna a R16  
	out DDRC,R16 ;Se habilita como salida El puerto C y se asigna a R16  
	out PORTB,R16 ;Se habilita pull up El puerto B y se asigna a R16  
	out PORTD,R16 ;Se habilita pull up El puerto D y se asigna a R16

uno: ;Etiqueta que indica el retorno para ejecutar un ciclo
	in R16,PINB ;Se utiliza como entrada el PIN B indicando que será usado en el R16  
	in R17,PIND ;Se utiliza como entrada el PIN D indicando que será usado en el R17  
	add R16,R17 ;Se Realiza la operación suma R16 <- R16 + R17  
	out PORTA,R16 ;Se Utiliza como salida el Puerto A usando el R16  
	in R16,SREG ;Se usa el R16 para mostrar el contenido de SREG  
	out PORTC,R16 ;Se usa como salida el puerto C mostrando el contenido de R16  
	rjmp uno ;Instrucción que salta a la etiqueta llamada uno  
