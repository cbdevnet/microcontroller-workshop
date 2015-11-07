.include "m8def.inc"
.cseg
.org 0
rjmp main

; This program displays a binary counter on pins PD0 to PD7
; This is just a fun example

setup:
	; Make all pins of Port D outputs
	ldi r16, 0xFF
	out DDRD, r16

	; Set up the stack
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	ldi r18, 1		; We're going to use r18 to store our current value

main:
	out PORTD, r18		; Output the current value of r18 to Port D
	rcall delay		; Wait a little
	inc r18			; Add 1 to r18
	;rol r18		; Optionally, rotate r18 left
	rjmp main		; Do it again

delay:				; A procedure to waste some time
	ldi r16, 0x64
delay_outer:
	ldi r17, 0xFF
delay_inner:
	dec r17
	brne delay_inner
	dec r16
	brne delay_outer
	ret
