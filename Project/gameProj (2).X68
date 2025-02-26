    ORG    $1000
EXIT    EQU 0            ; Used to exit the program

START:
    MOVE.B  #100, $4000      ; Set bravery points in memory location $4000
    LEA     $4000, A3        ; Assign address A3 to that memory location

    BSR     WELCOME          ; Branch to the WELCOME subroutine
    BSR     CHOICE           ; Branch to the CHOICE subroutine

    SIMHALT                  ; Halt simulator

*-------------------------------------------------------
*                   WELCOME SUBROUTINE
*-------------------------------------------------------
WELCOME:
    BSR     ENDL             ; New line
    LEA     WELCOME_MSG, A1  ; Load welcome message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message
    BSR     ENDL
    RTS                      ; Return



*-------------------------------------------------------
*                  CHOICE SUBROUTINE (READ INPUT)
*-------------------------------------------------------
CHOICE:
    LEA     CHOICE_MSG, A1   ; Load choice message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message

    LEA     USER_INPUT, A1   ; Load input buffer address
    MOVE.B  #2, D0           ; Max input length (1 char + NULL)
    TRAP    #15              ; Read input (D0=2 -> Read 1 char)
    
    MOVE.B  USER_INPUT, D1   ; Load user input into D1

    CMP.B   #'1', D1         ; Compare input to '1'
    BEQ     Listen          ; If '1', branch to FIGHT

    CMP.B   #'2', D1         ; Compare input to '2'
    BEQ     Grab             ; If '2', branch to RUN_AWAY

    BSR     INVALID_CHOICE   ; If input is invalid, show error
    BSR     CHOICE           ; Repeat input prompt
    RTS

*-------------------------------------------------------
*                   Listen SEQUENCE 1
*-------------------------------------------------------
Listen:
    BSR     ENDL
    LEA     Listen_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print fight message
    BSR     CHOICE1
    RTS     

CHOICE1:
    LEA     CHOICE_MSG, A1   ; Load choice message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message

    LEA     USER_INPUT, A1   ; Load input buffer address
    MOVE.B  #2, D0           ; Max input length (1 char + NULL)
    TRAP    #15              ; Read input (D0=2 -> Read 1 char)
    
    MOVE.B  USER_INPUT, D1   ; Load user input into D1

    CMP.B   #'1', D1         ; Compare input to '1'
    BEQ     Listen2          ; If '1', branch to FIGHT

    CMP.B   #'2', D1         ; Compare input to '2'
    BEQ     Resist             ; If '2', branch to RUN_AWAY

    BSR     INVALID_CHOICE   ; If input is invalid, show error
    BSR     CHOICE1           ; Repeat input prompt
    RTS
    
*-------------------------------------------------------
*                  Listen2 report SEQUENCE 2
*-------------------------------------------------------
Listen2:
    BSR     ENDL
    LEA     Listen2_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    RTS

*-------------------------------------------------------
*                  Resist report SEQUENCE 2
*-------------------------------------------------------
Resist:
    BSR     ENDL
    LEA     Resist_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    RTS
*-------------------------------------------------------
*                  Grab report SEQUENCE 1
*-------------------------------------------------------
Grab:
    BSR     ENDL
    LEA     Grab_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    BSR     CHOICE2
    RTS

CHOICE2:
    LEA     CHOICE_MSG, A1   ; Load choice message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message

    LEA     USER_INPUT, A1   ; Load input buffer address
    MOVE.B  #2, D0           ; Max input length (1 char + NULL)
    TRAP    #15              ; Read input (D0=2 -> Read 1 char)
    
    MOVE.B  USER_INPUT, D1   ; Load user input into D1

    CMP.B   #'1', D1         ; Compare input to '1'
    BEQ     Combat1          ; If '1', branch to FIGHT

    CMP.B   #'2', D1         ; Compare input to '2'
    BEQ     Game_OVER             ; If '2', branch to RUN_AWAY

    BSR     INVALID_CHOICE   ; If input is invalid, show error
    BSR     CHOICE2           ; Repeat input prompt
    RTS

Combat1:
    BSR     ENDL
    LEA     Combat1_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    BSR     Begin_Combat1
    RTS

*-------------------------------------------------------
*                  Begin combat segment
*-------------------------------------------------------
Begin_Combat1:
    MOVE.B  #10, PLAYER_HP     ; Set player HP to 10
    MOVE.B  #10, ENEMY_HP      ; Set enemy HP to 10

BATTLE_LOOP:
    LEA     Combat_options, A1
    MOVE.B  #14, D0
    TRAP    #15         ; Display attack or heal options
    MOVE.B  #2, D0
    TRAP    #15         ; Get player input
    MOVE.B  USER_INPUT, D1   ; Load user input into D1

    CMP.B   #'1', D1
    BEQ     PLAYER_ATTACK
    CMP.B   #'2', D1
    BEQ     PLAYER_HEAL
    BRA     BATTLE_LOOP

PLAYER_ATTACK:
    MOVE.B  #2, D1      ; Set upper limit for random number
    MOVE.B  #8, D0      ; Use TRAP #15 function 8 for RNG
    TRAP    #15         ; Call RNG (result in D1)
    AND.B   #1, D1      ; Ensure the number is 0 or 1
    CMP.B   #0, D1      ; Check if attack misses
    BEQ     MISS        ; If 0, attack misses
    
PLAYER_HEAL:
    ADD.B   #2, PLAYER_HP ; Heal player by 2 HP
    LEA     HEAL_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15         ; Print heal message
    BRA     ENEMY_TURN
    
HIT:
    SUB.B   #2, ENEMY_HP ; Enemy takes 2 damage
    LEA     HIT_MSG, A1  
    MOVE.B  #14, D0
    TRAP    #15         ; Print hit message
    BRA     CHECK_ENEMY_HP

MISS:
    LEA     MISS_MSG, A1 
    MOVE.B  #14, D0
    TRAP    #15         ; Print miss message
    BRA     ENEMY_TURN

CHECK_ENEMY_HP:
    CMP.B   #0, ENEMY_HP
    BLE     PLAYER_WINS ; If enemy HP is 0 or less, player wins

ENEMY_TURN:
    MOVE.B  #2, D1
    MOVE.B  #8, D0
    TRAP    #15         ; RNG for enemy attack
    AND.B   #1, D1
    CMP.B   #0, D1
    BEQ     ENEMY_MISS

ENEMY_HIT:
    SUB.B   #2, PLAYER_HP ; Player takes 2 damage
    LEA     ENEMY_HIT_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15         ; Print enemy hit message
    BRA     CHECK_PLAYER_HP

ENEMY_MISS:
    LEA     ENEMY_MISS_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15         ; Print enemy miss message
    BRA     BATTLE_LOOP

    
CHECK_PLAYER_HP:
    CMP.B   #0, PLAYER_HP
    BLE     ENEMY_WINS  ; If player HP is 0 or less, enemy wins
    BRA     BATTLE_LOOP

PLAYER_WINS:
    LEA     WIN_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15
    BRA     Game_Over

ENEMY_WINS:
    LEA     LOSE_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15
    BRA     Game_Over

*-------------------------------------------------------
*                INVALID INPUT HANDLING
*-------------------------------------------------------
INVALID_CHOICE:
    BSR     ENDL
    LEA     INVALID_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print invalid input message
    RTS

*-------------------------------------------------------
*                ENDL SUBROUTINE (NEW LINE)
*-------------------------------------------------------
ENDL:
    LEA     CRLF, A1    ; Load newline characters
    MOVE.B  #14, D0
    TRAP    #15         ; Print new line
    RTS                 ; Return

*-------------------------------------------------------
*                ENDS GAME
*-------------------------------------------------------
Game_Over:

*-------------------------------------------------------
*                  DATA SECTION
*-------------------------------------------------------
USER_INPUT:   DS.B  2   ; Reserve 2 bytes for input (1 char + NULL)
CHOICE_VAR:   DC.B  0

CRLF:   DC.B  $0D, $0A, 0   ; Carriage Return + Line Feed (New Line)

WELCOME_MSG:  DC.B 'You wake up inside of a hospital bed with little memory of what happened. You', $0D, $0A
              DC.B 'get greeted by a doctor assuring you that you were in a car accident.', $0D, $0A
              DC.B '1. Talk to the doctor and try to figure out what has happened in the accident.', $0D, $0A
              DC.B '2. try take a look at the medicul records to see what has happened.', $0D, $0A, 0

*-------------------------------------------------------
*                  SECTION A
*-------------------------------------------------------
Listen_MSG:   DC.B 'The doctor explains that the fault of the accident wasnt you just a drunk driver' ,$0D, $0A
              DC.B 'but would like to run a few tests on you to make sure nothing in your brain has' ,$0D, $0A
              DC.B 'been negatively affected.', $0D, $0A, 0
              
Listen2_MSG:  DC.B 'after some time talking with the doctor, you are given time to yourself you look' ,$0D, $0A
              DC.B 'at a news paper section about a recent murder that has happened with the killers' ,$0D, $0A
              DC.B 'name being oliver' ,$0D, $0A, 0
              
*-------------------------------------------------------
*                  SECTION A
*-------------------------------------------------------
Grab_MSG:     DC.B 'You quickly try to get your hands on the medical records but the doctor stops you' ,$0D, $0A
              DC.B 'and says that those documents are not to be looked at until the write up is done' ,$0D, $0A
              DC.B 'including the tests.', $0D, $0A, 0
              
Resist_MSG    DC.B 'You find the doctor is acting suspisious and dont belive anything he says to you' ,$0D, $0A
              
Combat1_MSG:   DC.B 'you lunge at the doctor and attack him the doctor defends himself initiating combat', $0D, $0A, 0

INVALID_MSG:  DC.B 'Invalid choice. Try again.', $0D, $0A, 0
CHOICE_MSG:  DC.B 'What will you do? (1 or 2): ', 0

*-------------------------------------------------------
*                  Combat system
*-------------------------------------------------------
Combat_options: DC.B 'Do you want to 1. attack enemy 2. attemt to heal' , $0D, $0A, 0
HIT_MSG:        DC.B 'You hit the enemy!' $0D, $0A, 0
MISS_MSG:       DC.B 'You missed!'  $0D, $0A, 0
ENEMY_HIT_MSG:  DC.B 'Enemy hits you!' ,$0D, $0A, 0
ENEMY_MISS_MSG: DC.B 'Enemy missed!' ,$0D, $0A, 0
WIN_MSG:        DC.B 'You defeated the enemy!' ,$0D, $0A, 0
LOSE_MSG:       DC.B 'You were defeated!' ,$0D, $0A, 0
HEAL_MSG:       DC.B 'You healed 2 HP!', $0D, $0A, 0

PLAYER_HP:      DS.B 1  ; Reserve 1 byte for player HP
ENEMY_HP:       DS.B 1  ; Reserve 1 byte for enemy HP

    END    START






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
