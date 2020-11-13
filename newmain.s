#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message  ; external subroutines
extrn	LCD_Setup, LCD_Write_Message
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
    
psect	udata_bank1 ; reserve data anywhere in RAM (here at 0x100)
Aa_array:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* message, data in programme memory, and its length *****
mess1a:
	db	'E','N','T','E','R'
	message1a_l	EQU 6	; length of data
	align	2

psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	goto	start
	
	; ******* Main programme ****************************************
start: 	lfsr	0, Aa_array	; Load FSR0 with address in RAM	
	movlw	low highword(mess1a)	; address of data in PM
	movwf	TBLPTRU, A		; load upper bits to TBLPTRU
	movlw	high(mess1a)	; address of data in PM
	movwf	TBLPTRH, A		; load high byte to TBLPTRH
	movlw	low(mess1a)	; address of data in PM
	movwf	TBLPTRL, A		; load low byte to TBLPTRL
	movlw	message1a_l	; bytes to read
	movwf 	counter, A		; our counter register
loop: 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter, A		; count down to zero
	bra	loop		; keep going until finished
		
	movlw	message1a_l	; output message to UART
	lfsr	2, Aa_array
	call	UART_Transmit_Message

	movlw	message1a_l	; output message to LCD
	addlw	0xff		; don't send the final carriage return to LCD
	lfsr	2, Aa_array
	call	LCD_Write_Message

	goto	$		; goto current line in code

	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst	