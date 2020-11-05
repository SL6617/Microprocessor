	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
main: 
    
    clrf TRISC, A ; set leds at port C as output
    call SPI_paralell_to_series
    call shift_series_to_paralell
    movlw   0xff	    ;setting the delay literal
    movwf   0x21	    ;register for delay literal
    call another_delay
    
    goto main
    
SPI_paralell_to_series:
    call SPI_MasterInit; initialises and sets up SPT
    movlw 0x08; paralell data to be coverted
    call SPI_MasterTransmit; convert to serial 
    call Wait_transmit
    return
   
shift_series_to_paralell:
    movlw 0x08, 1,0
    movwf 0x32
    call clock_it_in
    

clock_it_in:
    bCf PORTD,0
    BsF PORTD, 0
    decfsz 0x32, A ;0x32  adress to store number 8, so we clock in only 8 times
    bra clock_it_in
    return
    
    bra
SPI_MasterInit: ; Set Clock edge to negative
    bcf CKE ; CKE bit in SSP2STAT; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
    movlw (SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)
    movwf SSP2CON1, A ; SDO2 output; SCK2 output
    bcf TRISD, PORTD_SDO2_POSN, A ; SDO2 output
    bcf TRISD, PORTD_SCK2_POSN, A ; SCK2 output
    return
    
SPI_MasterTransmit: ; Start transmission of data (held in W)
    movwf SSP2BUF, A ; write data to output buffer
    return
    
Wait_Transmit: ; Wait for transmission to complete
    btfss SSP2IF ; check interrupt flag to see if data has been sent
    bra Wait_Transmit
    bcf SSP2IF ; clear interrupt flag
    return 

another_delay:
    decfsz	0x21, 1, 0
    bra     another_delay
    return