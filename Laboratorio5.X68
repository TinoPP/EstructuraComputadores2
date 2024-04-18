*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG $1000
    N: EQU 5
    V1: DC.W 10,-15,-100,89,-1
    V2: DS.W N
    START:                  ; first instruction of program

* Put program code here

    MOVE.W #N,D0
    SUBQ.W #1,D0
    LEA V2,A1
    MOVEA.L #0,A2
   
LOOP:
    
    MOVE.W -(A1),D1
    NOT.W D1
    ADDQ.W #1,D1
    MOVE.W D1,V2(A2)
    ADDQ.L #2,A2
        
    DBRA D0,LOOP
    
    
FINISH:
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
