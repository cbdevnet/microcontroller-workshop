.include "../m8def.inc"
.cseg
.org 0
rjmp setup

; This program scans the levels of all pins on Port C and
; mirrors their state as output to Port D.
; It can be used to introduce reading digital levels as well
; as an opportunity to explain pullup resistors and their use. 

setup:
	; Set all pins of Port C to output
	ldi r16, 0b11111111
	out DDRC, r16
	; Set all pins of Port D to input
	ldi r16, 0
	out DDRD, r16
	; Enable the pull-up resistors on all pins of Port D
	; When a pin is configured as an output, the corresponding bit in
	; PORTD controls its logic level. When the pin is configured as an
	; input, the bit controls whether the pullup resistor on that pin
	; is active.
	ldi r16, 0b11111111
	out PORTD, tr16

loop:
	in r16, PIND	; Read current levels at Port D
	out PORTC, r16	; Copy them to Port C as output
	rjmp main	; Do it again
