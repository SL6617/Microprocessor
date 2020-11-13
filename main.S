#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message  ; external subroutines
extrn	LCD_Setup, LCD_Write_Message
extrn	LCD_Setup_Bottom, LCD_delay_x4us
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine

;save message A 
psect	udata_bank1 ; reserve data anywhere in RAM (here at 0x100)
Aa_array:    ds 0x80 ; reserve 128 bytes for message data
psect	data   
messAa:
    	db	' ','E','N','T','E','R',' ','4','-','D','I','G','I','T'
	messAa_l   EQU	15	; length of datA
	align	2

psect	udata_bank2 ; reserve data anywhere in RAM (here at 0x200)
Ab_array:    ds 0x80 ; reserve 128 bytes for message data
psect	data    
messAb:
    	db	' ',' ',' ',' ','K','E','Y','C','O','D','E'
	messAb_l   EQU	12	; length of datA
	align	2
	
psect	code, abs	
rst: 	org 0x0
;LCD Setup Code
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART	
	goto	main
; ******* Main programme ****************************************
main:	call	writeAa
	call	writeAb

writeAa:
	call	LCD_Setup
	lfsr	0, Aa_array	; Load FSR0 with address in RAM	
	movlw	low highword(messAa)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(messAa)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(messAa)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	messAa_l	; bytes to read
	movwf 	counter, A		; our counter register
loop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop		; keep going until finished
		
	movlw	messAa_l	; output message to UART
	lfsr	2, Aa_array
	call	UART_Transmit_Message
	
	movlw	messAa_l	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, Aa_array
	call	LCD_Write_Message
	return

writeAb:
	call	LCD_Setup_Bottom
	lfsr	0, Ab_array	; Load FSR0 with address in RAM	
	movlw	low highword(messAb)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(messAb)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(messAb)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	messAb_l	; bytes to read
	movwf 	counter, A		; our counter register
loop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop		; keep going until finished
		
	movlw	messAb_l	; output message to UART
	lfsr	2, Ab_array
	call	UART_Transmit_Message
	return

	movlw	messAb_l	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, Ab_array
	call	LCD_Write_Message
	return

