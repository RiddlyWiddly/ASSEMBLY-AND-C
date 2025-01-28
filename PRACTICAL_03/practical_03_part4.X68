*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA BOSSY,   A1
    LEA BOSSX,   A2
    LEA PHEALTH, A3
    LEA PPoints, A4
    LEA PLAYERX, A5
    LEA PLAYERY, A6
    LEA BHEALTH, A7
    
    MOVE.W #10,   (A1)
    MOVE.W A1,    (A2)
    MOVE.B #10,   (A3)
    MOVE.L #100,  (A4)
    MOVE.W #0,    (A5)
    MOVE.W A5,    (A6)
    MOVE.L #1000, (A7) 
    

    SIMHALT             ; halt simulator

BOSSX   dc.w  $40
BOSSY   dc.w  $50
PHEALTH dc.b  $64
PPoints dc.l  $10
PLAYERX dc.w  $1
PLAYERY dc.w  $2
BHEALTH dc.l  $20
  

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
