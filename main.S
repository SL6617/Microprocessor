#include <xc.inc>

setup:
	banksel	PADCFG1  ;loading PADCFG1 into BSR	
	bsf	REPU  ;enabling pull-up 
	clrf	LATE, 0
	movlw	0x0f
	movwf	TRISE, 0   ;sets pins 0-3 high (input) & 4-7 low (output)
	clrf	TRISF	;PORTF all outputs
	bra	main

main:
	movlw	0x63
	movwf	0x20, 0
	movff	PORTE, LATF
	