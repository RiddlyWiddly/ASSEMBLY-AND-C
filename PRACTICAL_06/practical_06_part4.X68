*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*--
    ORG    $1000
START:                  ; first instruction of program

    LEA $4000, A7
    
    MOVE.B #1, -(SP)
    MOVE.B #2, -(SP)
    MOVE.B #3, -(SP)
    MOVE.B #4, -(SP)
    
    MOVE.B (SP)+, D1
    MOVE.B (SP)+, D1
    MOVE.B (SP)+, D1
    MOVE.B (SP)+, D1

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
