.include "m8def.inc"
.cseg
.org 0
rjmp setup	; This instruction is executed when the controller is first powered on

; Turn on a LED connected to PB0
; This is intended as a really basic introduction to
; working with the tools (software and hardware) needed for
; assembler programming, as well as an introduction to the basic structure
; of an assembly listing

; It can then be extended to turn the ping HIGH/LOW in rapid succession,
; leading up to introducing delay loops

setup:
	ldi r16, 0b00000001	; Load r16 with a 1 at the bit we want to set
	out DDRB, r16		; Output r16 into PORTB, turning PB0 into an output pin

main:
	out PORTB, r16		; Re-use r16's contents to turn the pin HIGH
	rjmp main		; Jump back
