	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
start:
    clrf TRISD, A		;PORTD output
    call SPI_MasterInit	;initialises and sets up SPT
    goto main
  
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
    
main: 
    movlw   0x19
    call SPI_MasterTransmit ;convert to serial 
    goto 0x0