#include <xc.inc>

extrn	LCD_delay_x4us

setup:
	banksel	PADCFG1 ; PADCFG1 is not in Access Bank
	bsf	REPU ; PortE pull-ups on
	clrf	LATE
	movlw	0x0f
	movwf	TRISE
	clrf	TRISF
	call	LCD_delay_x4us
