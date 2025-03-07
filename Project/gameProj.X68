ORG    $1000
EXIT    EQU 0            ; Used to exit the program

START:
    MOVE.B  #100, $4000      ; Set bravery points in memory location $4000
    LEA     $4000, A3        ; Assign address A3 to that memory location

    MOVE.B  #0, Scene
    
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
    BSR     Surgery
    RTS

Surgery:
    BSR     ENDL
    LEA     Surgery_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    BSR     Game_Over

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
    
    BEQ     Combat1          ; If '1', branch to Combat1

    CMP.B   #'2', D1         ; Compare input to '2'
    BEQ     Listen2          ; If '2', branch to Listen2

    BSR     INVALID_CHOICE   ; If input is invalid, show error
    BSR     CHOICE2           ; Repeat input prompt
    RTS

Combat1:
    BSR     ENDL
    LEA     Combat1_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    BSR     Begin_Combat1
    BSR     Truth
    RTS
    
Truth:
    BSR     ENDL
    LEA     Truth_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    BSR     Choice3
    RTS

CHOICE3:
    LEA     CHOICE_MSG, A1   ; Load choice message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message

    LEA     USER_INPUT, A1   ; Load input buffer address
    MOVE.B  #2, D0           ; Max input length (1 char + NULL)
    TRAP    #15              ; Read input (D0=2 -> Read 1 char)
    
    MOVE.B  USER_INPUT, D1   ; Load user input into D1

    CMP.B   #'1', D1         ; Compare input to '1'
    BEQ     FIGHT_BACK          ; If '1', branch to Combat1

    CMP.B   #'2', D1         ; Compare input to '2'
    BEQ     Run          ; If '2', branch to Run

    BSR     INVALID_CHOICE   ; If input is invalid, show error
    BSR     CHOICE3           ; Repeat input prompt
    RTS

FIGHT_BACK:
    BSR     ENDL
    LEA     FIGHT_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    BSR     Begin_Combat1
    BSR     CHOICE4
    RTS

Run:
    BSR     ENDL
    LEA     Run_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    BSR     Begin_Combat1
    BSR     CHOICE4
    RTS
    
End_Fight2:
    LEA     End_Fight2_MSG, A1   ; Load choice message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message
    BSR     CHOICE4
    RTS
    
CHOICE4:
    LEA     CHOICE4_MSG, A1   ; Load choice message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message

    LEA     USER_INPUT, A1   ; Load input buffer address
    MOVE.B  #2, D0           ; Max input length (1 char + NULL)
    TRAP    #15              ; Read input (D0=2 -> Read 1 char)
    
    MOVE.B  USER_INPUT, D1   ; Load user input into D1

    CMP.B   #'1', D1         ; Compare input to '1'
    BEQ     Good_Ending          ; If '1', branch to Combat1

    BSR     INVALID_CHOICE   ; If input is invalid, show error
    BSR     CHOICE4           ; Repeat input prompt
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
    
    LEA     USER_INPUT, A1   ; Load input buffer address
    MOVE.B  #2, D0
    TRAP    #15         ; Get player input
    
    MOVE.B  USER_INPUT, D1   ; Load user input into D1

    CMP.B   #'1', D1
    BEQ     PLAYER_ATTACK
    CMP.B   #'2', D1
    BEQ     PLAYER_HEAL
    CMP.B   #'3', D1
    BEQ     PLAYER_BUFF
    
    BRA     BATTLE_LOOP

PLAYER_ATTACK:
    MOVE.B  #2, D1      ; Set upper limit for random number (0 to 1)
    MOVE.B  #8, D0      ; Use TRAP #15 function 8 for RNG
    TRAP    #15         ; Call RNG (result is stored in D1)

    AND.B   #1, D1      ; Ensure the number is 0 or 1
    CMP.B   #0, D1      ; Check if attack misses
    BEQ     MISS        ; If 0, attack misses
    
HIT:
    SUB     #2, PLAYER_HP
    LEA     HIT_MSG, A1  
    MOVE.B  #14, D0
    TRAP    #15         ; Print hit message
    BRA     CHECK_ENEMY_HP
    
PLAYER_HEAL:
    ADD.B   #2, PLAYER_HP ; Heal player by 2 HP
    LEA     HEAL_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15         ; Print heal message
    BRA     ENEMY_TURN
    
PLAYER_BUFF:

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
    RTS

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
    
Check_Combat_Sequence:
    CMP.B   #'1', scene         ; Compare input to '1'
    BEQ     Combat1          ; If '1', branch to Combat1

    CMP.B   #'2', scene         ; Compare input to '2'
    BEQ     Listen2  
    
Good_Ending:
    BSR     ENDL
    LEA     Never_MSG, A1
    MOVE.B  #14, D0
    TRAP    #15              ; Print run message
    BSR     Begin_Combat1
    BSR     Choice5
    RTS

CHOICE5:
    LEA     CHOICE5_MSG, A1   ; Load choice message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message

    LEA     USER_INPUT, A1   ; Load input buffer address
    MOVE.B  #2, D0           ; Max input length (1 char + NULL)
    TRAP    #15              ; Read input (D0=2 -> Read 1 char)
    
    MOVE.B  USER_INPUT, D1   ; Load user input into D1

    CMP.B   #'1', D1         ; Compare input to '1'
    BEQ     Good          ; If '1', branch to good

    CMP.B   #'2', D1         ; Compare input to '2'
    BEQ     Bad          ; If '2', branch to bad

    BSR     INVALID_CHOICE   ; If input is invalid, show error
    BSR     CHOICE5           ; Repeat input prompt
    RTS

Good:
    LEA     GoodEnding_MSG, A1   ; Load choice message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message

Bad:
    LEA     BadEnding_MSG, A1   ; Load choice message
    MOVE.B  #14, D0
    TRAP    #15              ; Print message


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
              DC.B 'been negatively affected.', $0D, $0A
              DC.B '1. you belive in the doctor and his goal to help you' ,$0D, $0A
              DC.B '2. you sense something is off and try to retake power' ,$0D, $0A, 0
              
Listen2_MSG:  DC.B 'after some time talking with the doctor, you are given time to yourself you look' ,$0D, $0A
              DC.B 'at a news paper section about a recent murder that has happened with the killers' ,$0D, $0A
              DC.B 'name being oliver' ,$0D, $0A
              DC.B '1. you contine to listen to the doctor' ,$0D, $0A
              DC.B '2. ask about the killing' ,$0D, $0A, 0
              
              
*-------------------------------------------------------
*                  SECTION A
*-------------------------------------------------------
Grab_MSG:     DC.B 'You quickly try to get your hands on the medical records but the doctor stops you' ,$0D, $0A
              DC.B 'and says that those documents are not to be looked at until the write up is done' ,$0D, $0A
              DC.B 'including the tests.', $0D, $0A
              DC.B '1. A test in a hospital sounds weird attack!' ,$0D, $0A
              DC.B '2. The doctor stops you from grabing the paper you trust him' ,$0D, $0A, 0
              
Truth_MSG:    DC.B 'The doctor begs you to stop he will explain what is actualy happening in return' ,$0D, $0A
              DC.B 'you hear the doctor out and he explains the crash wasnt real but instaed this is' ,$0D, $0A
              DC.B 'a experament on hown the mind will react to a unknown envornment with no memmoy' ,$0D, $0A
              DC.B 'the reason this experiment is happening is to test a new tech... the doctor drops' ,$0D, $0A
              DC.B 'before he can finish what he was saying from a dart',$0D, $0A 
              DC.B '1. chase down the killer ' ,$0D, $0A
              DC.B '2. try to run away' , $0D, $0A, 0
              
Run_MSG:      DC.B 'after trying to run you realise that you are cornered and have to fight' , $0D, $0A, 0

FIGHT_MSG:    DC.B 'You hold your ground and prepare for a fight' , $0D, $0A, 0

Resist_MSG:    DC.B 'You find the doctor is acting suspisious and dont belive anything he says to you' ,$0D, $0A, 0
              
Combat1_MSG:   DC.B 'you lunge at the doctor and attack him the doctor defends himself initiating combat', $0D, $0A, 0

End_Fight2_MSG DC.B 'after winning the fight you realise that the person you just fought is actually you' , $0D, $0A, 0

INVALID_MSG:  DC.B 'Invalid choice. Try again.', $0D, $0A, 0

CHOICE_MSG:  DC.B 'What will you do? (1 or 2): ', 0

CHOICE4_MSG:  DC.B 'After checking what seams to be your own body you find a note that seems to be written ' ,$0D, $0A
             DC.B 'for youself saying william you must head to the main lab in this hospitel.Things wont' ,$0D, $0A
             DC.B 'make scense for now but you must keep going everything will be understood soon' ,$0D, $0A
             DC.B '1. go to final location' , $0D, $0A, 0
             
CHOICE5_MSG: DC.B 'after defeating the final boss you are given 2 options to destroy yourself with' ,$0D, $0A
             DC.B 'the data in your head so it cant fall into the wrong hands or try to live on even' ,$0D, $0A
             DC.B 'live on with memmories of a horrible man that can come back to haunt you' ,$0D, $0A
             DC.B '1. sacrifice' ,$0D, $0A
             DC.B '2. escape' $0D, $0A, 0

Never_MSG:   DC.B '*Alert* pops up on your hud with a shadowy figure explaining everything you went' ,$0D, $0A
             DC.B 'through wasnt real at least for u as ur just a consinsnes of someone else in a' ,$0D, $0A
             DC.B 'machines body. you are a repeat of multiple machine yous that dont take well' ,$0D, $0A
             DC.B 'this is why subconsusly you killed urself in a commbat senario with' ,$0D, $0A
             DC.B 'you are seen as property rather than something living the crash was real'  ,$0D, $0A
             DC.B 'The original over was a serial killer and in a high speed chase ended up with' ,$0D, $0A
             DC.B 'brain damage fracturing his memories which is why you are going through such' ,$0D, $0A
             DC.B 'confusion you might question what is being told to you. You might think and' ,$0D, $0A
             DC.B 'remember being there but your memmories are of a dead man. All is needed now' ,$0D, $0A
             DC.B 'is whatever resembles your brain' $0D, $0A, 0
             
Surgery_MSG: DC.B 'The doctor earned yout trust starting the tests and surgery soon after' ,$0D, $0A 
             DC.B 'killing you' ,$0D, $0A, 0

GoodEnding_MSG: DC.B 'you destroy yourself to stop anyone else having the same fate at least' ,$0D, $0A
                DC.B 'for a while' ,$0D, $0A, 0

BadEnding_MSG:  DC.B 'You try to flee and savyourself but as you try leave a squad is waiting for' ,$0D, $0A
                DC.B 'you they shut you down stealing the data to cause more harm and torture others',$0D, $0A, 0




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

*-------------------------------------------------------
*                  variables
*-------------------------------------------------------

PLAYER_HP:      DS.B 1  ; Reserve 1 byte for player HP
ENEMY_HP:       DS.B 1  ; Reserve 1 byte for enemy HP
SCENE:          DS.B 1  ; to help load combat scenes

    END    START





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
