# What's this

This repository contains the assembler listings I used for teaching a one-week
microcontroller workshop to high-school students in a university orientation program
(Schnupperstudium Informatik) in 2015.

The goal of this workshop was to create a simplified networked traffic light system,
wherein the participants each created their own implementation of the synchronization
protocol.

This repository is meant as a "teachers reference", which can optionally be handed out as reference
implementations after giving the students a chance to work on the problems themselves.

# What you need

The examples are written for the ATmega8 and were tested on its successor, the ATmega8A.
They should assemble just fine with [avra](http://avra.sourceforge.net/) or avr-as, after which you'll need to flash them
with e.g. [avrdude](http://www.nongnu.org/avrdude/).

I've created a bootable live system image based on TinyCoreLinux containing avra,
avrdude and some offline reference PDFs, but unfortunately I think there would be legal troubles
to simply uploading that. However, I would highly recommend doing the same when teaching
this workshop on computers that are not completely under your control (e.g. a bring-your-own-device setting).

On the hardware side of things, you'll need
	
	* The actual microcontrollers (ATmega8)
	* Red/green/yellow LEDs
	* Some resistors for the LEDs
	* AVR ICSP programmers (the cheap ones will do, too)
	* Some switches (DIP switch arrays work quite well)
	* Breadboards (kind of optional, but highly recommended)
	* a whole lot of those tiny wires to go on the breadboards

