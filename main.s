	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
;Programme FLASH read Setup Code
setup:	bcf	CFGS	;point to Flash program memory
	bsf	EEPGD	;access Flash program memory
	goto	start

MyTable: 
	db	0x00, 0x01, 0x02, 0x03  ;defines 1D array of data
	MyArray EQU 0x100   ;address in RAM where we want data saved
	Counter EQU 0x04    ;Address for counter variable. should be length of data list
 
start:
	lfsr	0, MyArray  ;load FSR0 with RAM address
	movlw	low highword(MyTable)	;address of data in PM
	movwf	TBLPTRU, 1
	movlw	high(MyTable)
	movwf	TBLPTRH, 1
	movlw	low(MyTable)
	movwf	TBLPTRL, 1
	movlw	4
	movwf	Counter, 1
	;movlw	0xd
	;movwf	0x13	;setting literal to be outputted to PORTC
       	
	;movwf	0x14
	;goto	loop

;lights_on:
	;movlw	0x0
	;movwf	TRISC, 1 ;Port C all outputs
	;movff	0x13, LATC
	
	;this loop reads db into FSR's
loop:	
	tblrd*+	    
	movff	TABLAT, POSTINC0
	;movf	0x14, 0	    ;moves current literal in 0x14 to W
	;cpfseq  MyArray, 1	;compares current RAM address w/W, if same --> 'return' to loop
	;goto	lights_on	;if W and FSR doesn't match --> output to PORTC
	decfsz	Counter, 1
	;incf 	0x14, 1, 0  ;increments 0x14	
	bra	loop	
	

;compare_loop:
;	movf	0x14, 0	    ;moves current literal in 0x14 to W
;	cpfseq  ___, 1	;compares current RAM address w/W, if same --> 'return' to loop
;	call	lights_on	;if W and FSR doesn't match --> output to PORTC
;	return