.include "m8def.inc"
.cseg
.org 0
rjmp setup

; This listing is the reference implementation of the final product
; of the workshop: a traffic light that is linkable via a ring topology,
; wherein each controller waits for a pulse on an input pin, then blinks
; its sequence and sends a pulse to the next controller in the ring.
; Two or more controllers can be synchronized by attaching multiple input
; pins to one output pin.

; Everything in this listing can be done by combining things learned
; in the previous examples. It might be beneficial to give students a fixed
; interface for this assignment (e.g. Ring is on PC5/PC4), in order to
; avoid problems when debugging/linking the controllers.
; This example greatly benefits from illustration with a logic analyzer.
; Remember to disable the pullups when linking multiple controllers.

; The ring is on pins PC5 (In) and PC4 (Out)
; Output is on PD0 (Red) / PD1 (Yellow) / PD2 (Green)

setup:
	; Prepare the stack in order to be able to use rcall/ret 
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	; Prepare the ring pins
	ldi r16, 0b00010000	; Pin 5 as input, Pin 4 as output
	out DDRC, r16		; Set the data direction on port C
	ldi r16, 0b00000000	; Switch off all the pullups (the remote controllers may have problems pulling the pins low otherwise)
	out PORTC, r16		; Output pullup state into PORTC
	
	; Prepare the LED output pins
	ldi r16, 0b00000111	; Pins 0,1,2 to output mode
	out DDRD, r16		; Set data direction on port D
	ldi r16, 0b00000001	; Turn on the red light in the beginning
	out PORTD, r16		; Set the levels on port D

main:
	sbis PINC, 5		; Check for a High pulse on PC5
	rjmp main		; Skip back
	rcall delay		; Wait a little (purely for optical purposes)
	rcall lightseq		; Blink the traffic light sequence
	rcall sendpulse		; Notify the next controller
	rjmp main		; Do it again
	
lightseq:			; Blink a traffic light sequence
	rcall yellowred
	rcall delay
	rcall green
	rcall delay_long
	rcall yellow
	rcall delay
	rcall red
	ret

sendpulse:
	ldi r16, 0b00010000
	out PORTC, r16
	rcall delay_short
	ldi r16, 0b00000000
	out PORTC, r16
	ret

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

delay_long:			; Waste some time
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	ret

delay:				; Waste a little less time
	rcall delay_short
	rcall delay_short
	rcall delay_short
	rcall delay_short
	ret

delay_short:			; Waste a short amount of time
        ldi r16, 0xFF
delay_outer: 
        ldi r17, 0xFF
delay_inner: 
	dec r17
        brne delay_inner
        dec r16
        brne delay_outer
        ret
