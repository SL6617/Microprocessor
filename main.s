	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0
	movwf	TRISC, A ; Port C all outputs
	movwf	0x06	    ;sets 0x06 at 0
	movlw	0x08	    ;sets W to max 4
	bra 	test
loop:	
        movff 	0x06, LATC
	incf 	0x06, 1, 0 
test:
	cpfsgt 	0x06, A
	bra 	loop
	
	goto	0x0	    ;Re-run program from start

	end	main
