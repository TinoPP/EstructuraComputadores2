*-----------------------------------------------------------
* Title      : PRAFIN24
* Written by : Constantino Perez Palacios
*              Iván Moreno De la Bandera
*              Ivan 
* Date       : 26/05/2024
* Description: Emulador de la SUIBC
*-----------------------------------------------------------
        ORG $1000
EMEM:   DC.W $A00C,$00A0,$7002,$5000,$A80D,$00A0,$4420,$63FD
        DC.W $00A0,$2060,$800E,$C000,$0003,$0004,$0000
EIR:    DC.W 0 ;eregistro de instruccion
EPC:    DC.W 0 ;econtador de programa
ER0:    DC.W 0 ;eregistro R0
ER1:    DC.W 0 ;eregistro R1
ER2:    DC.W 0 ;eregistro R2
ER3:    DC.W 0 ;eregistro R3
ESR:    DC.W 0 ;eregistro de estado (00000000 00000ZNC)

START:
    CLR.W EPC

FETCH:
    ;--- IFETCH: INICIO FETCH
        ;*** En esta seccion debeis introducir el codigo necesario para cargar
        ;*** en el EIR la siguiente instruccion a ejecutar, indicada por el EPC,
	    ;*** y dejar listo el EPC para que apunte a la siguiente instruccion
	
	        ; ESCRIBID VUESTRO CODIGO AQUI	    
	        
	        MOVE.W EPC,D0
	        MOVEA.W D0,A0
	        MOVE.W EMEM(A0),EIR
	        ADDQ.W #2,EPC
        
    ;--- FFETCH: FIN FETCH
    
    
    
    ;--- IBRDECOD: INICIO SALTO A DECOD
        ;*** En esta seccion debeis preparar la pila para llamar a la subrutina
        ;*** DECOD, llamar a la subrutina, y vaciar la pila correctamente,
        ;*** almacenando el resultado de la decodificacion en D1

    	    ; ESCRIBID VUESTRO CODIGO AQUI    	    
    	    
    	    MOVE.W #0,-(SP)
            MOVE.W EIR,-(SP)
    	    JSR DECOD
    	    ADDQ.W #2,SP
    	    MOVE.W (SP)+,D1
        
    ;--- FBRDECOD: FIN SALTO A DECOD
    
    
    
    ;--- IBREXEC: INICIO SALTO A FASE DE EJECUCION
        ;*** Esta seccion se usa para saltar a la fase de ejecucion
        ;*** NO HACE FALTA MODIFICARLA
    MULU #6,D1
    MOVEA.L D1,A1
    JMP JMPLIST(A1)
JMPLIST:
    JMP ESTO
    JMP ELOA
    JMP ECMP
    JMP EADD
    JMP ESUB
    JMP ENOR
    JMP ESET
    JMP EADQ
    JMP ETRA
    JMP EJMZ
    JMP EJMN
    JMP EJMI
    JMP EHLT
    ;--- FBREXEC: FIN SALTO A FASE DE EJECUCION
    
    
    
    ;--- IEXEC: INICIO EJECUCION
        ;*** En esta seccion debeis implementar la ejecucion de cada einstr.
	
	; ESCRIBID EN CADA ETIQUETA LA FASE DE EJECUCION DE CADA INSTRUCCION
ESTO:
        
        JSR DIRECCION_MEM
        MULU.W #2,D6
        MOVE.W D6,A1
        
        JSR REGISTRO_JMEM
        MOVE.W (A5),D1
        MOVE.W D1,EMEM(A1)
        
        BRA FETCH
        
ELOA:
        
        JSR REGISTRO_JMEM
        
        JSR DIRECCION_MEM
        MULU.W #2,D6
        MOVE.W D6,A1
        MOVE.W EMEM(A1),(A5)
        
        JSR ACT_FLAGSZN_OP
        
        BRA FETCH
        
ECMP:
        
        JSR REGISTRO_JMEM
        MOVE.W (A5),D1
        
        JSR REGISTRO_A
        MOVE.W (A4),D2
        
        SUB.W D1,D2
        JSR ACT_FLAGS_OP
        
        BRA FETCH
        
EADD:
        
        
        
        BRA FETCH
        
ESUB:
        
        JSR REGISTRO_JMEM
        MOVE.W (A5),D1
        
        JSR REGISTRO_A
        MOVE.W (A4),D2
        
        SUB.W D1,D2
        JSR ACT_FLAGS_OP
        
        
        
        BRA FETCH
        
ENOR:
        
        
        
        BRA FETCH
        
ESET:
        
        
        
        BRA FETCH
        
EADQ:
        
        ;SALTAR SUBRUTINA OBTENER REGISTRO Rb
        ;SALTAR SUBRUTINA OBTENER c
        ;EXTENSION DE SIGNO DE c (EXT)
        ;SUMAR 
        
        BRA FETCH
        
ETRA:
        
        
        
        BRA FETCH
        
EJMZ:
        
        MOVE.W ESR,D0
        BTST.L #2,D0
        BEQ FETCH
        ;SALTAR SUBRUTINA OBTENER m
        ;METER m EN EPC
        
        BRA FETCH
        
EJMN:
        
        MOVE.W ESR,D0
        BTST.L #1,D0
        BEQ FETCH
        ;SALTAR SUBRUTINA OBTENER m
        ;METER m EN EPC
        
        BRA FETCH
        
EJMI:
        
        ;SALTAR SUBRUTINA OBTENER m
        ;METER m EN EPC
        
        BRA FETCH
        
EHLT:
        
        SIMHALT

        BRA FETCH
        
    ;--- FEXEC: FIN EJECUCION
    
    

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

	        ; ESCRIBID VUESTRO CODIGO AQUI
	        
            ;Obtener "a" A4
            ;Obtener "b" A5
            ;Obtener "c" A6
            ;Obtener "m" dos opciones D6
            ;Obtener "j" dos opciones A5
	        
REGISTRO_A:
	        
	        MOVE.W EIR,D6
	        BTST #5,D6
	        BNE RA2
	        BTST #4,D6
	        BNE RA1
	        LEA.L ER0,A4
            BRA FIN_A
RA1:
            LEA.L ER1,A4
            BRA FIN_A
RA2:
            BTST #4,D0
	        BNE RA3
	        LEA.L ER2,A4
	        BRA FIN_A
RA3:
	        LEA.L ER3,A4
FIN_A:
	        RTS
            	        
	        
REGISTRO_B:
	        	        
	        MOVE.W EIR,D6
	        BTST #5,D6
	        BNE RB2
	        BTST #4,D6
	        BNE RB1
	        LEA.L ER0,A5
            BRA FIN_B
RB1:
            LEA.L ER1,A5
            BRA FIN_B
RB2:
            BTST #4,D6
	        BNE RB3
	        LEA.L ER2,A5
	        BRA FIN_B
RB3:
	        LEA.L ER3,A5
FIN_B:
	        RTS
	        
	        
REGISTRO_JMEM:
	        
	        MOVE.W EIR,D6
	        BTST #11,D6
	        BNE RJMEM1
	        LEA.L ER0,A5
	        BRA FIN_JMEM
RJMEM1:
	        LEA.L ER1,A5
FIN_JMEM:
	        RTS
	        
	        
REGISTRO_JOP:
	        
	        MOVE.W EIR,D6
	        BTST #11,D0
	        BNE RJOP1
	        LEA.L ER0,A5
	        BRA FIN_JOP
RJOP1:
	        LEA.L ER1,A5
FIN_JOP:
	        RTS
	        
	        
CONSTANTE:
            
            MOVE.W EIR,D0
            
            AND.W #$03FC,D0
	        LSR.W #2,D0
	        
	        RTS
	        
	        
DIRECCION_MEM:
            
            MOVE.W EIR,D5
            
            AND.W #$00FF,D5
	        
	        RTS
            
            
DIRECCION_JMP:
            
            MOVE.W EIR,D5
            
            AND.W #$0FF0,D5
	        LSR.W #4,D0
	        
	        RTS	        
	        
	        
ACT_FLAGS_OP:
            BTST #0,D6
            BNE SET_C_OP
            BCLR #0,D7
            BRA ACT_FLAGSZN_OP
SET_C_OP:
            BSET #0,D7
ACT_FLAGSZN_OP:
	        BTST #2,D6
            BNE SET_Z_OP
            BCLR #2,D7
            BRA FN_OP
SET_Z_OP:
            BSET #2,D7
FN_OP:
            BTST #3,D6
            BNE SET_N_OP
            BCLR #1,D7
            BRA FIN_ACT_FLAGS_OP
SET_N_OP:
            BSET #1,D7
FIN_ACT_FLAGS_OP:
            MOVE.W D7,ESR
            RTS
	        
	        
	        
	        
        
    ;--- FSUBR: FIN SUBRUTINAS
    
    

    ;--- IDECOD: INICIO DECOD
        ;*** Tras la etiqueta DECOD, debeis implementar la subrutina de 
        ;*** decodificacion, que debera ser de libreria, siguiendo la interfaz
        ;*** especificada en el enunciado
DECOD:
	        ; ESCRIBID VUESTRO CODIGO AQUI
	        
	        MOVE.W D0,-(SP)
	        MOVE.W 6(SP),D0
	        BTST #15,D0             ;X     
            BNE ETQ1
            BTST #14,D0             ;0X
            BNE ETQ2
            BTST #13,D0             ;00X
            BNE ETQ3
            BTST #12,D0             ;000X
            BNE ETQ4
            MOVE.W #9,8(SP)         ;0000
            BRA FDECOD
ETQ2:
            BTST #13,D0             ;01X
            BNE ETQ7
            BTST #12,D0             ;010X
            BNE ETQ9
            BTST #11,D0             ;0100X
            BNE ETQ10
            BTST #10,D0             ;01000X
            BNE ETQ12
            MOVE.W #2,8(SP)         ;010000
            BRA FDECOD
ETQ12:
            MOVE.W #3,8(SP)         ;010001
            BRA FDECOD
ETQ10:
            BTST #10,D0             ;01001X
            BNE ETQ11
            MOVE.W #4,8(SP)         ;010010
            BRA FDECOD
ETQ11:
            MOVE.W #5,8(SP)         ;010011
            BRA FDECOD
ETQ9:
            MOVE.W #6,8(SP)         ;0101
            BRA FDECOD
ETQ7:
            BTST #12,D0             ;011X
            BNE ETQ8
            MOVE.W #7,8(SP)         ;0110
            BRA FDECOD
ETQ8:
            MOVE.W #8,8(SP)         ;0111
            BRA FDECOD            
ETQ1:
            BTST #14,D0             ;1X
            BNE ETQ5
            BTST #13,D0             ;10X
            BNE ETQ6
            MOVE.W #0,8(SP)         ;100
            BRA FDECOD
ETQ6:
            MOVE.W #1,8(SP)         ;101
            BRA FDECOD
ETQ5:
            MOVE.W #12,8(SP)        ;11
            BRA FDECOD
ETQ3:
            MOVE.W #11,8(SP)        ;0010
            BRA FDECOD
ETQ4:
            MOVE.W #10,8(SP)        ;0001
FDECOD:
            MOVE.W (SP)+,D0
	        RTS

    ;--- FDECOD: FIN DECOD
    END    START
    
    
    



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
