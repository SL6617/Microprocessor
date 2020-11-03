	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
start:	
	;clrf	PORTF
	;banksel	ANCON1
	;movlw	0x1F
	;movwf	ANCON1
	;movlw	0x0F
	;movwf	ANCON
	goto	main

write:
	clrf	TRISE, A    ; enablePORTE output
	bsf	PORTD, 0, A  ;CP2 high
	bsf	PORTD, 1, A  ;OE*2 high
	bcf	PORTD,0,A   ;sets CP2 as low
	movlw   0x05	    ;literal to be written into memory chip 1
	movwf   PORTE, A
	movlw   0xff	    ;setting the delay literal
	movwf   0x21	    ;register for delay literal
	call	another_delay
	bsf	PORTD,0,A    ;sets CP2 as high
	setf	TRISE, A    ;TRISE all high
	return
write2:

	clrf	TRISE, A    ;PORTE as output
	bsf	PORTD, 2, A  ;CP1 high
	bsf	PORTD, 3, A  ;OE*1 high
	bcf	PORTD,2,A   ;sets CP1 as low
	movlw   0xff	    ;literal to be written into memory chip 2
	movwf   PORTE, A
	movlw   0xff	    ;setting the delay literal
	movwf   0x21	    ;register for delay literal
	call	another_delay
	bsf	PORTD,2,A    ;sets CP1 as high
	setf	TRISE, A    ;PORTE as input
	return
read:	
	setf	TRISE, A    ;PORTE as input	
	clrf	TRISF, A    ;PORTC all output	
	bcf	PORTD,1,A   ;OE2* set as low
	call	another_delay
	movff	PORTE, LATF, A ;reading memory output will be on PORTC
	bsf	PORTD,1,A   ;sets OE2* as high
	setf	TRISE, A 
	return
read2:	
	setf	TRISE, A    ;TRISE all high	
	clrf	TRISH, A    ;PORTH all output
	bcf	PORTD,3,A   ;OE1* set as low
	movff	PORTE, LATH, A ;reading memory output will be on PORTH
	bsf	PORTD,3,A   ;sets OE1* as high
	setf	TRISE, A 
	return

another_delay:
	decfsz	0x21, 1, 0
	bra     another_delay
	return

 main:
	
	;call    write2
	;call	read2	
	call    write
	call    read
	
	

    	end     main 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

