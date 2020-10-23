	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs

main:
	org	0x0
	goto	start

	org	0x100	; Main code starts here at address 0x100

start:
	movlw	0x63	;setting delay literal
	movwf	0x20	;move literal from line above into this address
	
	movlw 	0x0
	movwf	TRISC, A ; Port C all outputs
	movwf	0x06	    ;sets 0x06 at 0		
	goto 	test

loop:	
	
	movff 	0x06, LATC
	incf 	0x06, 1, 0
	goto    test
		
delay:  
	decfsz  0x20, 1, 0 
	movlw	0x63	;setting cascaded delay literal
	movwf	0x21
	call	another_delay
	tstfsz	0x20, 0
	bra	delay
	return

another_delay:
	decfsz	0x21, 1, 0
	bra     another_delay
	return

test:	
	call	delay
	movlw	0x03
	cpfsgt 	0x06, A
	bra 	loop
	
	goto	0x0		
	end	main	
