
*-----------------------------------------------------------
* Title      : PRAFIN24
* Written by : Constantino Perez Palacios
*              Ivan Moreno De la Bandera
* Date       : 27/05/2024
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
	        ADD.W D0,D0
	        MOVEA.W D0,A0
	        MOVE.W EMEM(A0),EIR
	        ADDQ.W #1,EPC
        
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
        
        ;OBTENEMOS POSICION DE MEMORIA DE M
        JSR DIRECCION_MEM
        MULU.W #2,D5
        MOVE.W D5,A1
        
        ;OBTENEMOS POSICION DE MEMORIA DE Rj
        JSR REGISTRO_JMEM
        ;GUARDAMOS LO QUE HAY EN M EN LA POSICION DE Rj
        MOVE.W (A5),D1
        MOVE.W D1,EMEM(A1)
        
        BRA FETCH
        
ELOA:
        ;OBTENEMOS POSICION DE MEMORIA DE Rj
        JSR REGISTRO_JMEM
        
        ;OBTENEMOS POSICION DE MEMORIA DE M
        JSR DIRECCION_MEM
        ;GUARDAMOS LO QUE HAY EN Rj EN LA POSICION DE M
        MULU.W #2,D5
        MOVE.W D5,A1
        MOVE.W EMEM(A1),D3
        MOVE.W D3,(A5)
        ;PREPARACION ACTUALIZACION DE FLAGS
        MOVE.W SR,D6
        MOVE.W ESR,D7
        ;ACTUALIZACION DE FLAGS
        JSR ACT_FLAGSZN_OP
        
        BRA FETCH
        
ECMP:
        ;SALTAR SUBRUTINA OBTENER REGISTRO Rj
        JSR REGISTRO_JOP
        MOVE.W (A5),D1
        ;SALTAR SUBRUTINA OBTENER REGISTRO Ra
        JSR REGISTRO_A
        MOVE.W (A4),D2
        ;NEGAMOS EL REGISTRO Ra
        NEG D2
        ;LE SUMAMOS 1 A Ra
        ;ADDQ.W #1,D2
        ;SUMAMOS Rj Y Ra(A'+1) (EQUIVALE A RESTAR Rj Y Ra)
        ADD.W D1,D2
        ;PREPARACION ACTUALIZACION DE FLAGS
        MOVE.W SR,D6
        MOVE.W ESR,D7
        
        ;ACTUALIZACION DE FLAGS
        JSR ACT_FLAGS_OP
        
        BRA FETCH
        
EADD:   
        ;SALTAR SUBRUTINA OBTENER REGISTRO Ra
        JSR REGISTRO_A
        MOVE.W (A4),D2
        ;SALTAR SUBRUTINA OBTENER REGISTRO Rj
        JSR REGISTRO_JOP
        MOVE.W (A5),D3
        
        ;SUMAMOS Rj Y Ra
        ADD.W D3,D2
        ;PREPARACION ACTUALIZACION DE FLAGS
        MOVE.W SR,D6
        MOVE.W ESR,D7
        ;MOVEMOS EL RESULTADO DE LA SUMA A Rj
        MOVE.W D2,(A5)
        ;ACTUALIZACION DE FLAGS
        JSR ACT_FLAGS_OP
        
        BRA FETCH
        
ESUB:
        ;SALTAR SUBRUTINA OBTENER REGISTRO Rj
        JSR REGISTRO_JOP
        MOVE.W (A5),D1
        ;SALTAR SUBRUTINA OBTENER REGISTRO Ra
        JSR REGISTRO_A
        MOVE.W (A4),D2
        ;NEGAMOS EL REGISTRO Ra
        NEG D2
        ;LE SUMAMOS 1 A Ra
        ;ADDQ.W #1,D2
        ;SUMAMOS Rj Y Ra(A'+1) (EQUIVALE A RESTAR Rj Y Ra)
        ADD.W D1,D2
        ;PREPARACION ACTUALIZACION DE FLAGS
        MOVE.W SR,D6
        MOVE.W ESR,D7
        ;MOVEMOS EL RESULTADO A Rj
        MOVE.W D2,(A5)
        ;ACTUALIZACION DE FLAGS
        JSR ACT_FLAGS_OP
        
        
        
        BRA FETCH
        
ENOR:
        ;SALTAR SUBRUTINA OBTENER REGISTRO Ra
        JSR REGISTRO_A
        MOVE.W (A4),D1
        
        ;SALTAR SUBRUTINA OBTENER REGISTRO Rj
        JSR REGISTRO_JOP
        MOVE.W (A5),D2
        
        ;HACEMOS UN OR DE Ra Y Rj Y NEGAMOS EL RESULTADO (EQUIVALE A HAVER NOR)
        OR.W D1,D2
        NOT D2
        
        ;PREPARACION ACTUALIZACION DE FLAGS
        MOVE.W SR,D6
        MOVE.W ESR,D7
        MOVE.W D2,(A5)
        
        ;ACTUALIZACION DE FLAGS
        JSR ACT_FLAGSZN_OP
        
        
        BRA FETCH
        
ESET:
        ;SALTAR SUBRUTINA OBTENER REGISTRO Rb
        JSR REGISTRO_B     
    
        ;SALTAR SUBRUTINA OBTENER EL VALOR c
        JSR CONSTANTE
        
        ;EXTENSION DE SIGNO DE c Y LO GUARDAMOS EN Rb
        EXT.W D4
        MOVE.W D4,(A5)
        
        ;PREPARACION ACTUALIZACION DE FLAGS
        MOVE.W SR,D6
        MOVE.W ESR,D7
        
        ;ACTUALIZACION DE FLAGS
        JSR ACT_FLAGSZN_OP
        
        
        BRA FETCH
        
EADQ:
        
        ;SALTAR SUBRUTINA OBTENER REGISTRO Rb
        JSR REGISTRO_B
        ;SALTAR SUBRUTINA OBTENER c
        JSR CONSTANTE
        
        ;EXTENSION DE SIGNO DE c Y LO SUMAMOS A Rb Y GUARDAMOS EN Rb
        EXT.W D4
        ADD D4,(A5)
        
        ;PREPARACION ACTUALIZACION DE FLAGS
        MOVE.W SR,D6
        MOVE.W ESR,D7
        
        ;ACTUALIZACION DE FLAGS
        JSR ACT_FLAGS_OP
        ;EXTENSION DE SIGNO DE c (EXT)
        ;SUMAR 
        
        BRA FETCH
        
ETRA:

        ;SALTAR SUBRUTINA OBTENER REGISTRO Ra
        JSR REGISTRO_A
        MOVE.W (A4),D1
        
        ;SALTAR SUBRUTINA OBTENER REGISTRO Rb        
        JSR REGISTRO_B
        
        ;COPIAMOS LO QUE HAY EN Ra EN Rb
        MOVE.W D1,(A5)
        
        ;PREPARACION ACTUALIZACION DE FLAGS
        MOVE.W SR,D6
        MOVE.W ESR,D7
        
        ;ACTUALIZACION DE FLAGS
        JSR ACT_FLAGSZN_OP
        
        
        BRA FETCH
        
EJMZ:   ;INSTRUCCION QUE REALIZA UN SALTO SI EL FLAG Z ESTA ACTIVADO
        
        MOVE.W ESR,D0
        BTST.L #2,D0
        BEQ FETCH
        JSR DIRECCION_JMP
        MOVE.W D5,EPC
                
        BRA FETCH
        
EJMN:   ;INSTRUCCION QUE REALIZA UN SALTO SI EL FLAG N ESTA ACTIVADO
        
        MOVE.W ESR,D0
        BTST.L #1,D0
        BEQ FETCH
        JSR DIRECCION_JMP
        MOVE.W D5,EPC
                
        BRA FETCH
        
EJMI:   ;INSTRUCCION QUE REALIZA UN SALTO INCONDICIONAL
        
        JSR DIRECCION_JMP
        MOVE.W D5,EPC
        
        BRA FETCH
        
EHLT:   ;INSTRUCCION QUE FINALIZA EL PROGRAMA
        
        SIMHALT

        BRA FETCH
        
    ;--- FEXEC: FIN EJECUCION
    
    

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

	        ; ESCRIBID VUESTRO CODIGO AQUI
	        
            ;Obtener "a" A4
            ;Obtener "b" A5
            ;Obtener "c" D4
            ;Obtener "m" dos opciones D5
            ;Obtener "j" dos opciones A5
	        
REGISTRO_A:                         ;Obtencion del registro Ra
	        
	        MOVE.W EIR,D6
	        BTST #5,D6
	        BNE RA2
	        BTST #4,D6
	        BNE RA1
	        LEA.L ER0,A4            ;ER0
            BRA FIN_A
RA1:
            LEA.L ER1,A4            ;ER1
            BRA FIN_A
RA2:
            BTST #4,D6
	        BNE RA3
	        LEA.L ER2,A4            ;ER2
	        BRA FIN_A
RA3:
	        LEA.L ER3,A4            ;ER3
FIN_A:
	        RTS
            	        
	        
REGISTRO_B:                         ;Obtencion del registro Rb
	        
	        MOVE.W EIR,D6
	        BTST #1,D6
	        BNE RB2
	        BTST #0,D6
	        BNE RB1
	        LEA.L ER0,A5            ;ER0
            BRA FIN_B
RB1:
            LEA.L ER1,A5            ;ER1
            BRA FIN_B
RB2:
            BTST #0,D6
	        BNE RB3
	        LEA.L ER2,A5            ;ER2
	        BRA FIN_B
RB3:
	        LEA.L ER3,A5            ;ER3
FIN_B:
	        RTS
	        
	        
REGISTRO_JMEM:                      ;obtencion del registro Rj
	                                ;para las instrucciones con la memoria
	        MOVE.W EIR,D6
	        BTST #11,D6
	        BNE RJMEM1
	        LEA.L ER0,A5            ;ER0
	        BRA FIN_JMEM
RJMEM1:
	        LEA.L ER1,A5            ;ER1
FIN_JMEM:
	        RTS
	        
	        
REGISTRO_JOP:                       ;Obrencion del registro Rj
	                                ;para las instrucciones de operaciones
	        MOVE.W EIR,D6
	        BTST #6,D6
	        BNE RJOP1
	        LEA.L ER0,A5            ;ER0
	        BRA FIN_JOP
RJOP1:
	        LEA.L ER1,A5            ;ER1
FIN_JOP:
	        RTS
	        
	        
CONSTANTE:                          ;Obtencion de la constante 
            
            MOVE.W EIR,D4
            
            AND.W #$03FC,D4         ;Mascara para el obtener los bits de c
	        LSR.W #2,D4             ;Desplazamiento hacia la derecha de c
	        
	        RTS
	        
	        
DIRECCION_MEM:                      ;Obtencion de la posicion de memoria
                                    ;para las intrucciones transferencia
            MOVE.W EIR,D5
            
            AND.W #$00FF,D5         ;Mascara para el obtener los bits de m
	        
	        RTS
            
            
DIRECCION_JMP:                      ;Obtencion de la posicion de memoria
                                    ;para las intrucciones de salto
            MOVE.W EIR,D5
            
            AND.W #$0FF0,D5         ;Mascara para el obtener los bits de m
	        LSR.W #4,D5             ;Desplazamiento hacia la derecha de m
	        
	        RTS	        
	        
	        
ACT_FLAGS_OP:                       ;Actualizacion de los flags
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
