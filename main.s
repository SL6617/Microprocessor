	#include <pic18_chip_select.inc>
	#include <xc.inc>
	
;DON'T FORGET RETURN AT END OF SUBROUTINES!!!!
psect	code, abs
setup:
    call setup

main:
    call is_human_there ; runs the detection check from the PIR then thermal sensor
    call alarm_system_on ;turn on buzzer, voice message, flasing lights
    call keycode_check
    call mega_alarm
     
setup:;initialize then programme devices but don't turn on
    light_set_up:
    buzzer_set_up: - S
    LCD_set_up:  -B

    keypad_set_up: -B
    PIR_sensor_set_up:- S
    thermal_sensor_set_up:-S
    fruit_board_set_up: - B
return ; returns to setup

is_human_there:
    check_PIR_status:
	; is the voltage trigered?
	; no - bra check_PIR_status
	; yes - NOP
    trigger_thermal_sensor:
	; check for human warmth
	; no - bra check PIR - status
	; yes - return to main to trigger alarm
 

alarm_system_on:
    call LCD1: ; this will be LCD displaying 'enter code'
    buzzer_on:
    lights_on:
    voice1_on: ; 'get out of my house'
    
;person is trying to enter the keycode
  
keycode_check:
    ;set up counter register to 
    ;tries to enter code
    ;if correct call - disable_alarm
    ;if wrong call LCD2: 'incorrect, try again'
    ;increment counter (up to 3) up by one
    ;if ocunter in register in 3 skip next line
    ;bra keycode_check
    ;return
 
disable_alarm:
;disables alarm and everything
;end
 
LCD1: ;'enter code'
LCD2: ;incorrect try again
LCD3: ;'system locked - calling police'

mega_alarm:
    mega_buzzer_on:
    mega_lights_on:
    voice2_on: ;'police being called'
