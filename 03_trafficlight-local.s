.include "m8def.inc"
.cseg
.org 0
rjmp setup

	; Blink a traffic light sequence
	; Outputs:
	;	PD0 - Red LED
	;	PD1 - Yellow LED
	;	PD2 - Green LED

setup:
	; Set up the stack in order to be 
	; able to use rcall
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	; Set up the Data Direction Register (DDR)
	; for Port D to have PD0/PD1/PD2 configured as outputs
	ldi r16, 0b00000111
	out DDRD, r16

lightseq:
	rcall red		; Output a red light
	rcall delay_long	; Waste a bit of time...
	rcall yellowred		; Light to yellow/red combination
	rcall delay		; Wait a shorter while
	rcall green		; Change to green light
	rcall delay_long	; Wait a longer time
	rcall yellow		; Change to yellow light
	rcall delay		; Wait a short time
	rjmp lightseq		; Do it again

red:
	ldi r16, 0b00000001	; Set up the r16 so that the bit controlling the Red LED is set
	out PORTD, r16		; Output the register r16 to PORTD in order to change the Pin
	ret			; Jump back to caller

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

delay_long:			; Repeatedly wait a short time in order to waste some more time
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	rcall delay
	ret

delay:				; Waste a short amount of time
        ldi r16, 0xFF
delay_outer: 
        ldi r17, 0xFF
delay_inner: 
	dec r17
        brne delay_inner
        dec r16
        brne delay_outer
        ret
