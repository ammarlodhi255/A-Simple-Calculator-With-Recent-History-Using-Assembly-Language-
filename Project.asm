.MODEL SMALL
.STACK 100H
 
LFCR MACRO 
    MOV AH, 2
    MOV DL, 10
    INT 21H
    MOV DL, 13
    INT 21H    
ENDM

.DATA   

FILENAME DB "CALCULATOR_HISTORY.txt", 0
HANDLE DW ?
PROCESS DB 15 DUP(?)
MUL_DIV DB 12 DUP(?)
RESULT_LENGTH DW 0

ATKS DB "              ********************************************$"
WELCOME DB "              **** WELCOME TO THE ASSEMBLY CALCULATOR ****$" 
ATKS2 DB "              ********************************************$"
WELCOME2 DB "*** HISTORY OF YOUR CALCULATIONS WILL BE SAVED IN CALCULATOR_HISTORY.TXT ***$"
           
OPTION1 DB "PRESS 1 FOR ADDTION (2 DIGIT ADDITION ALLOWED)$"
OPTION2 DB "PRESS 2 FOR SUBTRACTION (2 DIGIT SUBTRACTION ALLOWED)$"
OPTION3 DB "PRESS 3 FOR MULTIPLICATION$"
OPTION4 DB "PRESS 4 FOR DIVISION$"
ENTER_CHOICE DB "ENTER YOUR CHOICE: $" 
FIRST_NUM DB "ENTER FIRST NUM: $"
SECOND_NUM DB "ENTER SECOND NUM: $" 
INSTRUCTION1 DB "IF ITS A SINGLE DIGIT NUMBER, WRITE THE NUMBER AFTER 0, i.e. 01$"
PROMPT_AGAIN DB "DO YOU WANT TO USE THE CALCULATOR AGAIN? Y/N: $" 
CHOICE DB ?
NUM1 DB ?
NUM2 DB ?

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX  
     
    MOV AH, 9
    LEA DX, ATKS
    INT 21H
    LFCR
    
    MOV AH, 9
    MOV DX, OFFSET WELCOME
    INT 21H 
    LFCR
    
    MOV AH, 9
    LEA DX, ATKS2
    INT 21H
    
    LFCR  
    LFCR 
    
    MOV AH, 9
    LEA DX, WELCOME2
    INT 21H
    
    LFCR     
    LFCR 
    
    START:
    MOV AH, 9
    LEA DX, OPTION1
    INT 21H
    LFCR
    
    MOV AH, 9
    LEA DX, OPTION2
    INT 21H
    LFCR 
    
    MOV AH, 9
    LEA DX, OPTION3
    INT 21H
    LFCR    
    
    MOV AH, 9
    LEA DX, OPTION4
    INT 21H
    LFCR   
    LFCR
    
    MOV AH, 9
    LEA DX, ENTER_CHOICE
    INT 21H
    
    MOV AH, 1
    INT 21H
    
    MOV CHOICE, AL
    
    LFCR
    LFCR
    
    CMP CHOICE, '1'
    JE ADDITION_LABEL
    CMP CHOICE, '2'
    JE SUBTRACTION_LABEL
    CMP CHOICE, '3'
    JE MULTIPLICATION_LABEL
    CMP CHOICE, '4'
    JE DIVISION_LABEL 
    JMP EXIT
     
    ADDITION_LABEL:
        MOV AH, 9
        LEA DX, INSTRUCTION1
        INT 21H
        LFCR 
        LFCR
         
        CALL ADDITION
        LFCR
        MOV AH, 9
        LEA DX, PROCESS
        INT 21H 
        CALL GET_LENGTH
        CALL WRITE_TO_FILE    
        JMP REPROMPT
    
    SUBTRACTION_LABEL:
        MOV AH, 9
        LEA DX, INSTRUCTION1
        INT 21H  
        LFCR
        LFCR
        CALL SUBTRACTION 
        LFCR
        MOV AH, 9
        LEA DX, PROCESS
        INT 21H
        CALL GET_LENGTH
        CALL WRITE_TO_FILE
        JMP REPROMPT
    
    MULTIPLICATION_LABEL:
        LFCR
        CALL MULTIPLICATION
        LFCR
        MOV AH, 9
        LEA DX, MUL_DIV
        INT 21H
        CALL WRITE_TO_FILE2
        JMP REPROMPT
    
    DIVISION_LABEL:
        LFCR
        CALL DIVISION
        LFCR
        MOV AH, 9
        LEA DX, MUL_DIV
        INT 21H
        CALL WRITE_TO_FILE2
        JMP REPROMPT
    
    REPROMPT:
        LFCR
        LFCR
        MOV AH, 9
        LEA DX, PROMPT_AGAIN
        INT 21H
        MOV AH, 1
        INT 21H
        MOV CHOICE, AL
        LFCR
        LFCR
        CMP CHOICE, 'Y'
        JE START  
    EXIT:   
       MOV AH, 4CH
       INT 21H   
        
ENDP MAIN

MULTIPLICATION PROC
LEA DI, MUL_DIV
    MOV AL, 10
    STOSB
    MOV AL, 13
    STOSB
     
    MOV AH, 09H
    MOV DX, OFFSET FIRST_NUM
    INT 21H
    MOV AH, 01H
    INT 21H 
    
    STOSB
    
    SUB AL, 30H
    MOV NUM1, AL
    
    MOV AL, ' '
    STOSB
    MOV AL, '*'
    STOSB
    MOV AL, ' '
    STOSB
    
    LFCR 
    MOV AH, 09H
    MOV DX, OFFSET SECOND_NUM
    INT 21H
    MOV AH, 01H
    INT 21H 
    
    STOSB
    
    SUB AL, 30H
    MOV NUM2, AL
    
    MOV AL, ' '
    STOSB
    MOV AL, '='
    STOSB
    MOV AL, ' '
    STOSB
    
    MOV AL, NUM1
    MOV BL, NUM2
    MUL BL  
    ;
    AAM
    
    ADD AH, 30H
    ADD AL, 30H
    MOV BX, AX
    
    MOV AL, BH
    STOSB     
    
    MOV AL, BL
    STOSB
    
    MOV AL, '$'
    STOSB
    RET    
ENDP MULTIPLICATION  


ADDITION PROC
MOV AH, 9
    LEA DX, FIRST_NUM
    INT 21H 
    
    LEA DI, PROCESS
    
    MOV AL, 10
    STOSB
    MOV AL, 13
    STOSB
    
    MOV AH, 1
    INT 21H   
    
    STOSB
    
    SUB AL, 48
    MOV BH, AL
    
    INT 21H
    
    STOSB
    
    SUB AL, 48
    MOV BL, AL
    
    MOV AL, ' '
    STOSB
    MOV AL, '+'
    STOSB
    MOV AL, ' ' 
    STOSB

    LFCR     
    MOV AH, 9
    LEA DX, SECOND_NUM
    INT 21H 
        
    MOV AH, 1
    INT 21H  
    
    STOSB
    
    SUB AL, 48
    MOV CH, AL
    
    INT 21H
     
    STOSB
    
    SUB AL, 48
    MOV CL, AL
    
    ADD BL, CL
    
    MOV AL, BL
    MOV AH, 00H
    AAA ;ADJUST AFTER ADDITION
    
    MOV CL, AL
    
    ADD BH, AH
    ADD BH, CH
    
    MOV AL, BH
    MOV AH, 00H
    AAA
    
    MOV BX, AX
    
    LFCR
    
    MOV AL, ' '   
    STOSB
    MOV AL, '='
    STOSB
    MOV AL, ' '
    STOSB
    
    ADD BH, 48
    
    MOV AL, BH
    STOSB
    
    ADD BL, 48
    
    MOV AL, BL
    STOSB
    
    ADD CL, 48
    
    MOV AL, CL
    STOSB
    
    MOV AL, '$'
    STOSB
        
    RET      
ENDP ADDITION


SUBTRACTION PROC
MOV AH, 9
    LEA DX, FIRST_NUM
    INT 21H 
    
    LEA DI, PROCESS
    
    MOV AL, 10
    STOSB
    MOV AL, 13
    STOSB
    
    MOV AH, 1
    INT 21H
     
    STOSB
    
    SUB AL, 48
    MOV BH, AL
    
    INT 21H
    STOSB
    
    SUB AL, 48
    MOV BL, AL
    
    MOV AL, ' '
    STOSB
    MOV AL, '-'
    STOSB
    MOV AL, ' ' 
    STOSB
    
    LFCR
    
    MOV AH, 9
    LEA DX, SECOND_NUM
    INT 21H
    
    MOV AH, 1
    INT 21H
    
    STOSB
    
    SUB AL, 48
    MOV CH, AL
    
    INT 21H
    
    STOSB
    
    SUB AL, 48
    MOV CL, AL
    
    SUB BL, CL
    
    MOV AL, BL
    MOV AH, 00H
    AAS
    
    MOV CL, AL
    
    SUB BH, AH
    SUB BH, CH
    
    MOV AL, BH
    MOV AH, 00H
    AAS
    
    MOV BX, AX
    
    LFCR
    
    MOV AL, ' '
    STOSB
    MOV AL, '='
    STOSB
    MOV AL, ' '
    STOSB
    
    ADD BH, 48
    MOV AL, BH
    STOSB   
    
    ADD BL, 48
    MOV AL, BL
    STOSB
    
    ADD CL, 48
    MOV AL, CL
    STOSB
    
    MOV AL, '$'
    STOSB
    
    RET    
ENDP SUBTRACTION


DIVISION PROC
LEA DI, MUL_DIV
    
    MOV AL, 10
    STOSB
    MOV AL, 13
    STOSB
    
    MOV AH, 09H
    MOV DX, OFFSET FIRST_NUM
    INT 21H
    MOV AH, 01H
    INT 21H
    
    STOSB
    
    SUB AL, 30H
    MOV NUM1, AL
    
    MOV AL, ' '
    STOSB
    MOV AL, '/'
    STOSB
    MOV AL, ' '
    STOSB
    
    LFCR

    MOV AH,09H
    MOV DX,OFFSET SECOND_NUM
    INT 21H
    MOV AH,01H
    INT 21H 
    
    STOSB
    
    SUB AL, 30H
    MOV NUM2, AL
    
    MOV AL, ' '
    STOSB
    MOV AL, '='
    STOSB
    MOV AL, ' '
    STOSB
    
    MOV CL, NUM1
    MOV CH, 00
    MOV AX, CX
    DIV NUM2
    MOV AH, 00
    AAD
    
    ADD AH, 30H
    Add AL, 30H
    MOV BX,AX 
    
    MOV AL, BH
    STOSB
    MOV AL, BL
    STOSB
    
    MOV AL, '$'
    STOSB
    RET    
ENDP DIVISION

WRITE_TO_FILE2 PROC
;load file handler
    MOV DX ,OFFSET FILENAME
    MOV AL, 1
    MOV AH, 3DH
    INT 21H
    
    ;Appending File
    MOV BX, AX
    MOV CX, 0
    MOV AH, 42H
    MOV AL, 02H
    INT 21H
    
    ;Writing File   
    MOV CX, 12
    MOV DX, OFFSET MUL_DIV
    MOV AH, 40H
    INT 21H
    
    ;close file
    MOV AH,3EH
    INT 21H

    RET    
ENDP WRITE_TO_FILE2
 
WRITE_TO_FILE PROC
;load file handler
    MOV DX ,OFFSET FILENAME
    MOV AL, 1
    MOV AH, 3DH
    INT 21H
    
    ;Appending File
    MOV BX, AX
    MOV CX, 0
    MOV AH, 42H
    MOV AL, 02H
    INT 21H
    
    ;Writing File   
    MOV CX, 15
    MOV DX, OFFSET PROCESS
    MOV AH, 40H
    INT 21H
    
    ;close file
    MOV AH,3EH
    INT 21H

    RET    
ENDP WRITE_TO_FILE

GET_LENGTH PROC
SUB CX, CX
    
    MOV BX, 0
    MOV CX, 25
    
    L1:
        MOV AL, PROCESS[BX]
        CMP AL, '$'
        JE EXT

        INC BX
        INC RESULT_LENGTH 
    LOOP L1
    
    DEC RESULT_LENGTH 
    EXT:
    RET    
ENDP GET_LENGTH

END MAIN