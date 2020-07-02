#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <util/delay.h>

#define step1  8
#define step2  4
#define step3  2
#define step4  1

void config_io(void){
	DDRC = 0x0F;
	DDRD = 0b11111011;
	PORTD = _BV(PD2);
	MCUCR = _BV(ISC01);
	GICR = _BV(INT0);
	sei();
}

void retardo(void){
	int i;
	for(i=0; i<25; i++) _delay_ms(10);
}

void secuencia1(void){
	PORTC = step1;
	retardo();
	PORTC = step2;
	retardo();
	PORTC = step3;
	retardo();
	PORTC = step4;
	retardo();
}

ISR(INT0_vect){
	PORTC = step4;
	retardo();
	PORTC = step3;
	retardo();
	PORTC = step2;
	retardo();
	PORTC = step1;
	retardo();
}

int main(void){
	config_io();
	while(1){
		secuencia1();
	}
}
