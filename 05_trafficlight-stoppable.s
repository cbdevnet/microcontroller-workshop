.include "m8def.inc"
.cseg
.org 0
rjmp setup

; This program blinks the normal traffic light sequence on
; PD0 (Red), PD1 (Yellow) and PD2 (Green), which will stop
; if PB1 is pulled Low - but not until the sequence has stopped
; correctly (e.g., if PB1 is pulled Low while the light is Green,
; the sequence will continue until it is red and then stop and wait
; for the pin to go High again.

; This program serves as an introduction to using input and output
; concurrently, as well as to the sbic/sbis instructions.

setup:
	; Set up the stack pointer
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	; Set up the output pins
	ldi r16, 0b00000111
	out DDRD, r16
	; Set up the input pins
	ldi r16, 0b00000000
	out DDRB, r16
	; Enable the pullup resistor on PB1
	ldi r16, 0b00000010
	out PORTB, r16

selectmode:
	sbic PINB, 1	; Skip the next instruction if PB1 is Low
	rjmp off	; Turn the light red
	rjmp lightseq	; Blink the traffic light sequence

lightseq:		; Blink a standard traffic light sequence
	rcall red
	rcall delay_long
	rcall yellowred
	rcall delay
	rcall green
	rcall delay_long
	rcall yellow
	rcall delay
	rjmp selectmode

off:
	rcall red
	rjmp selectmode

red:
	ldi r16, 0b00000001
	out PORTD, r16
	ret

yellow:
	ldi r16, 0b00000010
	out PORTD, r16
	ret

green:
	ldi r16, 0b00000100
	out PORTD, r16
	ret

yellowred:
	ldi r16, 0b00000011
	out PORTD, r16
	ret

delay_long:
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	ret

delay:
        ldi r16, 0xFF
delay_outer: 
        ldi r17, 0xFF
delay_inner: 
	dec r17
        brne delay_inner
        dec r16
        brne delay_outer
        ret
