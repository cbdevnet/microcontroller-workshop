.include "m8def.inc"
.cseg
.org 0
rjmp setup

; This program blinks an LED connected to PB0
; It can be used to demonstrate the speed at which even
; microcontrollers operate (the delay loop decrements from 255
; to zero 255 times (16 bit), yet the delay is still barely visible), 
; as well as to introduce the concept of a stack needed to track 
; from where procedures were called.
 
setup:
	ldi r16, 0b00000001		; Load a 1 (output mode) into the bit corresponding to PB0
	out DDRB, r16			; Set PB0 to output mode
	
	; Set up the stack pointer
	; RAMEND is a 16-bit variable defined in m8def.inc which contains
	; the length of the addressable SRAM on the chip. SPL/SPH are two 8-bit registers
	; containing the stack pointer
	ldi r16, low(RAMEND)		; Load the lower 8 bit of RAMEND into r16
	out SPL, r16			; Output r16 into SPL (Stack Pointer Low)
	ldi r16, high(RAMEND)		; Load the upper half of RAMEND into r16
	out SPH, r16			; Output that half into SPH (Stack Pointer High)

main:	
	ldi r16, 0b00000001		; Load a 1-bit at the position corresponding to PB0 into r16
	out PORTB, r16			; Pull PB0 High
	;rcall delay
	;rcall delay
	ldi r16, 0			; Load r16 with 0
	out PORTB, r16			; Pull PB0 Low
	;rcall delay
	;rcall delay
	rjmp main			; Do it again

delay:					; Waste some time
	ldi r16, 0xFF			; Load r16 with all 1's
delay_outer:
	ldi r17, 0xFF			; Load r17 with all 1's
delay_inner:
	dec r17				; Subtract 1 from r17
	brne delay_inner		; If the result of the last operation was not 0, go back to delay_inner
	dec r16				; Subtract 1 from r16
	brne delay_outer		; If the result of the last operation was not 0, go back to delay_outer
	ret				; Jump back to the caller
