    ORG    $1000
; D0 Used for trap codes and counting enemies
; D1 Used for player's health
; D2 Used for enemy positions
; D4 Used for enemy count
; A0 Used for counting enemies
; A1 Used for progress messages
; A2 Used for PLAYER_X
; A3 Used for ENEMY_POSITIONS
; A4 Used for power-up positions

DAMAGE EQU 10
HEAL   EQU 20  ; Increased healing amount

START:                  ; First instruction of the program
    LEA     PLAYER_X, A2
    LEA     ENEMY_POSITIONS, A3
    BRA     GAME_LOOP

GAME_LOOP:
    BSR     COUNT_ENEMIES
    MOVE.B  D0, D4

    LEA     MSG_GAMELOOP, A1
    BSR     DRAW

    BSR     UPDATE
    BRA     GAME_LOOP

UPDATE:
    MOVE.B  PLAYER_HEALTH, D1

    LEA     MSG_HEALTH, A1
    BSR     DRAW

    MOVE.B  #3, D0
    TRAP    #15

    LEA     CRLF, A1
    BSR     DRAW

    CMP     #0, D1
    BLE     GAME_OVER
    ADD.L   #1, (A2)
    BSR     COLLISION
    RTS

DRAW:
    MOVE.B  #13, D0
    TRAP    #15
    RTS

COLLISION:
    MOVE.B  #1, D5
    LEA     ENEMY_POSITIONS, A3
    LEA     POWER_UPS, A4

ITERATE:
    CMP     D5, D4
    ADD.B   #1, D5
    BEQ     GAME_LOOP
    BNE     CHECK_POWER_UPS
    BNE     CHECK_ENEMIES
    RTS

CHECK_POWER_UPS:
    MOVE.L  (A4)+, D2
    MOVE.L  (A2), D3

    CMP.L   D2, D3
    BEQ     HEAL_HEALTH
    BNE     ITERATE

CHECK_ENEMIES:
    MOVE.L  (A3)+, D2
    MOVE.L  (A2), D3

    CMP.L   D2, D3
    BEQ     REDUCE_HEALTH
    BNE     ITERATE

REDUCE_HEALTH:
    LEA     MSG_COLLISION, A1
    BSR     DRAW

    SUB.B   #DAMAGE, PLAYER_HEALTH

    LEA     MSG_HEAL, A1
    BSR     DRAW

    BRA     GAME_LOOP

HEAL_HEALTH:
    LEA     MSG_HEALING, A1
    BSR     DRAW

    ADD.B   #HEAL, PLAYER_HEALTH

    LEA     MSG_HEALED, A1
    BSR     DRAW

    BRA     GAME_LOOP

GAME_OVER:
    LEA     MSG_GAMEOVER, A1
    BSR     DRAW
    SIMHALT             ; Halt simulator

COUNT_ENEMIES:
    MOVE.B  #0, D0
    LEA     ENEMY_POSITIONS, A0

COUNT_ENEMIES_LOOP:
    TST.L   (A0)+
    BEQ     END_COUNTING

    ADD.B   #1, D0
    BRA     COUNT_ENEMIES_LOOP

END_COUNTING:
    RTS

PLAYER_X        DC.L    1
PLAYER_HEALTH   DC.B    100
MSG_HEALTH      DC.B    'Health: ', 0
MSG_GAMELOOP    DC.B    'GAME LOOP', 0
MSG_COLLISION   DC.B    'Collision', 0
MSG_GAMEOVER    DC.B    'GAME OVER', 0
MSG_HEAL        DC.B    'Taking damage', 0
MSG_HEALING     DC.B    'Healing...', 0
MSG_HEALED      DC.B    'Healed!', 0
CRLF            DC.B    $0D, $0A, 0
ENEMY_POSITIONS DC.L    20, 30, 40, 50, 60, 70, 80, 90, 200, 300, 500, 0
POWER_UPS       DC.L    20, 30, 40, 50, 60, 70, 80, 90

    END    START        ; Last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
