	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
;Programme FLASH read Setup Code
setup:	bcf	CFGS	;point to Flash program memory
	bsf	EEPGD	;access Flash program memory
	goto	start

MyTable: 
	db	0x0, 0x01, 0x02, 0x03  ;defines 1D array of data
	MyArray EQU 0x400   ;address in RAM where we want data saved
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

loop:	tblrd*+
	movff	TABLAT, POSTINC0
	decfsz	Counter, 1
	bra	loop
	goto	0
	

