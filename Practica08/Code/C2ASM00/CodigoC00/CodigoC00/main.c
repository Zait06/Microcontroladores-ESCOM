#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/sleep.h>

#define step1  8
#define step2  4
#define step3  2
#define step4  1

void config_io(void){
	DDRC = 0x0F;
	DDRD = 0b11111011;
	PORTD = _BV(PD2);
}
void retardo(void){
	int i;
	for(i=0; i<25000; i++);
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
void secuencia2(void){
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
		switch(PIND){
			case(4):
			secuencia1();
			break;
			case(0):
			secuencia2();
			break;
		}
	}
}