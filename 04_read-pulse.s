.include "m8def.inc"
.org 0
rjmp setup

; This code shows how to detect a pulse on an input pin,
; which can be used as a simple way of synchronizing two 
; microcontrollers, or even more than that in a ring/bus 
; topology. This listing can serve as an introduction to
; basic networking topologies as well as showing how to
; react to input. It also requires the students to keep 
; in mind the state of the ports/pins they are using.
; This example benefits from a demonstration with a logic
; analyzer. Keep in mind that you should probably turn
; off the pullup resistors when connecting input pins to 
; another controller's output pin.
; The sendpulse method can be left to the students to
; implement.
;
; Output on PC5 (LED) and PC4 (Pulse Out)
; Input on PC3 (Pulse In)
;
; Remember to connect PC3 to Ground in order to pull it low,
; as the pulse is expected to be High (and the pullup resistor
; will pull the port High when not connected to anything)

setup:
	; Prepare the stack pointer
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	; Configure PC5 / PC4 as Outputs
	ldi r16, 0b00110000
	out DDRC, r16
	
	; Pullup on PC3
	ldi r16, 0b00001000
	out PORTC, r16

main:
	; Wait for a High pulse on PC3
	sbis PINC, 3		; Skip the next instruction if PC3 is High
	rjmp main		; Skip back
	rcall ledon		; Turn on the LED
	rcall delay_long	; Wait a while
	rcall ledoff		; Turn it off again
	rcall sendpulse		; Send a pulse on the output pin (PC4)
	rjmp main

sendpulse:
	ldi r16, 0b00011000 	; Set the bit corresponding to PC4, while keeping the pullup resistor bit for PC3
	out PORTC, r16		; Write to PORTC
	rcall delay		; Wait a little
	ldi r16, 0b00001000	; Turn PC4 off, again keeping mind the pullup resistor
	out PORTC, r16		; Write to PORTC
	ret			; Go back to call site

ledon:
	ldi r16, 0b00101000	; Turn on PC5 and keep the pullup resistor on PC3 in mind
	out PORTC, r16		; Write to PORTC
	ret

ledoff:
	ldi r16, 0b00001000	; Turn off PC5
	out PORTC, r16
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
