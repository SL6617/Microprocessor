	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
start:
    clrf TRISD, A		;PORTD output
    setf TRISF, A		;PORTF input (output LEDs)
    call SPI_MasterInit	;initialises and sets up SPT


main: 
    call SPI_parallel_to_series
    call shift_series_to_parallel
    ;movlw   0xff		;setting the delay literal
    ;movwf   0x21		;register for delay literal
    ;call another_delay
    ;movff PORTD, LATF, A
    end main
    
SPI_parallel_to_series:
    movlw 0x08			;parallel data to be coverted
    call SPI_MasterTransmit ;convert to serial 
    return
   
shift_series_to_parallel:
    movlw   0x08		;count down from 8 so only 8 things clocked in
    movwf   0x32			;address to put counter in
    ;bsf    PORTD, 9, A		;set the MR as high so shit happens
    call    clock_it_in		;should be on outputs now  i think lol
    return			

clock_it_in:
    bcf	    PORTD, 6, A		;clock pulse port D low
    movlw   0xff		;setting the delay literal
    movwf   0x21
    call    another_delay
    bsf	    PORTD, 6, A		;clock pulse HIGH - data should be read on the rise of this.
    decfsz  0x32, A		;address to store number 8, so we clock in only 8 times
    bra	    clock_it_in
    return
  
SPI_MasterInit:			;Set Clock edge to negative
    bcf CKE ; CKE bit in SSP2STAT; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
    movlw (SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)
    movwf SSP2CON1, A ; SDO2 output; SCK2 output
    bcf TRISD, PORTD_SDO2_POSN, A ; SDO2 output
    bcf TRISD, PORTD_SCK2_POSN, A ; SCK2 output
    return
    
SPI_MasterTransmit:
    ;Starts transmission of data (held in W)
    movwf SSP2BUF, A				;write data to output buffer
Wait_Transmit: ; Wait for transmission to complete
    btfss SSP2IF ; check interrupt flag to see if data has been sent
    bra Wait_Transmit
    bcf SSP2IF ; clear interrupt flag
    return 

another_delay:
    decfsz	0x21, 1, 0
    bra		another_delay
    return