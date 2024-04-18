*------------------------------------------------
* Titulo : P1 (2023-2024) - Sieve of Eratosthenes
* Autores: Constantino Pérez y Alumno 2
*------------------------------------------------
    ORG $1000
N:  EQU 10
P:  DS.B N
    DS.W 0
C:  DS.W 1
*--------------------------------------------

AUX: DS.B N ;Array auxiliar para ir tachando los multiplos

START:                  ; first instruction of program

    ADD.W #N,D0
    SUBQ.W #1,D0
    LEA P,A0

LP:
    
    MOVE.B #0,(A0)+
    
    DBRA D0,LP
    
    MOVE.W #N,D0
    SUBQ.W #1,D0
    MOVE.W #1,D1
    LEA AUX,A0
    
    ;Llenar array AUX con bucle
LAUX:
    
    MOVE.B D1,(A0)+
    ADDQ.W #1,D1
    
    DBRA D0,LAUX
    
    ;Limpieza y preaparacion de registros
    MOVE.W #N,D0
    SUBQ.W #1,D0
    MOVE.W #0,D1
    LEA AUX,A0
    LEA P,A5
    
    
    ;Comienzo bucle comprobar que valores son primos hasta N veces
SIEVE:
    
    ;Obtencion valor actual
    MOVE.B (A0)+,D1
    CMP #0,D1
    BEQ NNUMBER
    CMP #1,D1
    BEQ CASE1    
    
    ;Tachar los multiplos recorriendo el array AUX con un bulce desde la
    ;posicion actual hasta N con postincremento
    MOVE.W #N,D3
    SUBQ.W #1,D3
    SUB.W D1,D3
    MOVE.W A0,A1

SIGNUM:
    MOVE.W #0,D2
    MOVE.B (A1)+,D2

MULTIPLOS:
    SUB.W D1,D2
    BGT MULTIPLOS
    BEQ TACHAR
    BMI NEXTM
    
TACHAR:
    SUBQ.W #1,A1
    MOVE.B #0,(A1)+
    
NEXTM:
    DBRA D3,SIGNUM
    
CASE1:
    ;Si no esta tachado meter D1 en P (tachado sera hacer que sea valor 0)
    MOVE.B D1,(A5)+

    ;Sumar uno a D5 que contara cuantos valores primos tenemos
    ADDQ.W #1,D5
    
NNUMBER:
    ;Comenzar el bucle SIEVE
    DBRA D0,SIEVE
    
    ;Guardar el valor de D5 a C
    MOVE.W D5,C
    

FINISH:

    SIMHALT             ; halt simulator

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
