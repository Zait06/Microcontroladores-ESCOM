# Microcontroladores-ESCOM

## Descripción
En este repositorio se encuentras las practicas de microcontroladores.

En cada carpeta se encuentra divididos el código y las simulaciones en una carpeta, además, se encuentra el reporte de dicha práctica.

## Prácticas:
1. Contador binario.
2. Operaciones binarias:
	* Sumador
	* Multiplicador
3. Decodificadro hexadecimal.
4. Contador de 0 a 99.
5. Interruptores.
6. Interruptores y timers en LCD.
7. Convertidor Analógico Digital.
8. De código C a código ASM.

## Compilacion
```sh
# compilacion
avr-gcc -g -mmcu=atmega8535 -o mainS.elf ContadorBin.S -I/usr/avr/include

# generar hex
avr-objcopy -j .text -j .data -O ihex main.elf main.hex
```

## Integrantes del equipo:
- Esquivel Pérez Jonathan Alfredo
- Hernández López Ángel Zait
- Salgado Gallegos Jesús
- Sánchez Pizano Irving Daniel

## Guia y ayuda
https://gitlab.com/jjchico-edc/avr-bare
