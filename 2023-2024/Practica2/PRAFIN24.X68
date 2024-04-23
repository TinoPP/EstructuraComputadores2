*-----------------------------------------------------------
* Title      : PRAFIN24
* Written by : <nombres completos de los autores>
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
    	    
    	    MOVE.W EIR,-(SP)
    	    JSR DECOD
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
ELOA:
ECMP:
EADD:
ESUB:
ENOR:
ESET:
EADQ:
ETRA:
EJMZ:
EJMN:
EJMI:
EHLT:
    ;--- FEXEC: FIN EJECUCION
    
    

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

	        ; ESCRIBID VUESTRO CODIGO AQUI
        
    ;--- FSUBR: FIN SUBRUTINAS
    
    

    ;--- IDECOD: INICIO DECOD
        ;*** Tras la etiqueta DECOD, debeis implementar la subrutina de 
        ;*** decodificacion, que debera ser de libreria, siguiendo la interfaz
        ;*** especificada en el enunciado
DECOD:
	        ; ESCRIBID VUESTRO CODIGO AQUI
	        
	        BTST #15,D0             ;X     
            BNE ETQ1
            BTST #14,D0             ;0X
            BNE ETQ2
            BTST #13,D0             ;00X
            BNE ETQ3
            BTST #12,D0             ;000X
            BNE ETQ4
            MOVE.W #9,              ;0000
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
            MOVE.W #2,              ;010000
            BRA FDECOD
ETQ12:
            MOVE.W #3,              ;010001
            BRA FDECOD
ETQ10:
            BTST #10,D0             ;01001X
            BNE ETQ11
            MOVE.W #4,              ;010010
            BRA FDECOD
ETQ11:
            MOVE.W #5,              ;010011
            BRA FDECOD
ETQ9:
            MOVE.W #6,              ;0101
            BRA FDECOD
ETQ7:
            BTST #12,D0             ;011X
            BNE ETQ8
            MOVE.W #7,              ;0110
            BRA FDECOD
ETQ8:
            MOVE.W #8,              ;0111
            BRA FDECOD            
ETQ1:
            BTST #14,D0             ;1X
            BNE ETQ5
            BTST #13,D0             ;10X
            BNE ETQ6
            MOVE.W #0,              ;100
ETQ6:
            MOVE.W #1               ;101
            BRA FDECOD
ETQ5:
            MOVE.W #12,             ;11
            BRA FDECOD
ETQ3:
            MOVE.W #11,             ;0010
            BRA FDECOD
ETQ4:
            MOVE.W #10,             ;0001
FDECOD:
	        RTS

    ;--- FDECOD: FIN DECOD
    END    START
    
    
    
    ;Obtener "a"
    ;Obtener "b"
    ;Obtener "c"
    ;Obtener "m" dos opciones
    ;Obtener "j" dos opciones


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
