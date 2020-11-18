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
	
delay:
	decfsz  0x20, 1, 0
	movlw   0x63
	movwf   0x21
	call    another_delay
	tstfsz  0x20, 0
	bra	delay
	return
	    
another_delay:
	decfsz  0x21, 1, 0
	bra	another_delay
	return