	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
start:	
	goto	main

write:
	clrf	TRISD, A    ;PORTD is output only
	setf	TRISE, A
	bsf	PORTD, 0, A  ;CP2 high
	bsf	PORTD, 1, A  ;OE*2 high

	clrf	TRISE, A    ;PORTE low

	bcf	PORTD,0,A   ;sets CP2 as low
	movlw   0x04	    ;literal to be written into memory chip
	movwf   PORTE, A
	movlw   0xff	    ;setting the delay literal
	movwf   0x21	    ;register for delay literal
	call another_delay
	bsf	PORTD,0,A    ;sets CP2 as high
	
	return
    
read:	
	clrf	TRISF, A    ;PORTC all output
	
	bcf	PORTD,1,A   ;OE2* set as low
	
	call another_delay
	movff	PORTE, LATF, A ;reading memory output will be on PORTC
	
	bsf	PORTD,1,A   ;sets OE2* as high
	setf	TRISE, A    ;TRISE all high
	return



another_delay:
	decfsz	0x21, 1, 0
	bra     another_delay
	return
    

 main:
	call    write
	call    read
    	end     main 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

