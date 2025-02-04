*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.B  #100, $3000
    MOVE.W  #1000, $2000
    LEA     $3000, A1
    LEA     $3000, A2
    BSR TAKING_DAMAGE
    BSR BOSS_TAKING_DAMAGE
    
BACK_IN_THE_GAME:
    BSR HEALTH_PICKUP
    BRA GAME_END
    
TAKING_DAMAGE:
    SUB.B   #20, (A1)
    BRA     BACK_IN_THE_GAME
    
BOSS_TAKING_DAMAGE:
    SUB.W   #20, (A2)

HEALTH_PICKUP:
    ADD.B   #10, (A1)
    RTS
    
GAME_END:
    MOVE.B  #$00, (A1)

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
