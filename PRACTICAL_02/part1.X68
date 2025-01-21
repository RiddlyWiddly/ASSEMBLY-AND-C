*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  

    MOVE.L #%100, D0 ;binary to decimal
    MOVE.L #$100, D1 ;hexadecimal (decimal 256), so D1 becomes 00000100 in hexadecimal.
    MOVE.L #100, D2 ; decimal to hex (64)

    MOVE.L D0, $3000 
    MOVE.L D1, $3010
    MOVE.L D2, $3020
    SIMHALT             



    END    START         



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
