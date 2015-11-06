/******************************************************************************
* @FILE calc.s
* @BRIEF simple calculator program
*
* Simple calculator to do arithmetic sum, difference, multiply and maximum.
*
* @AUTHOR ANISH TIMILA
******************************************************************************/
 
    .global main
    .func main
   
main:
    BL  _scanf
    MOV R8, R0
    BL _getchar             @ branch to scanf procedure with return
    MOV R10, R0
    BL _scanf
    MOV R9, R0
    MOV R1, R10
    MOV R2, R8		    @ move return value R0 to argument register R1
    MOV R3, R9
    BL _compare
    MOV R1, R0              @ move R0 to R1
    BL _reg_dump
    LDR R0, =Printf_Output  @ R0 contains formatted string address
    BL  printf              @ branch to print procedure with return
    B   main                @ branch to exit procedure with no return
  
_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return

#_printf:
 #   PUSH {LR}               @ store LR since printf call overwrites
 #   LDR R0, =printf_str     @ R0 contains formatted string address
 #   MOV R1, R1              @ R1 contains printf argument (redundant line)
 #   BL printf 		    @ call printf
 #   POP {PC}                @ return
    
_compare:
    CMP R1, #'+' 
    BLEQ _add               @ compare against the constant char '@'
    CMP R1, #'-'
    BLEQ _sub             
    CMP R1, #'*'
    BLEQ _mul            
    CMP R1, #'M'
    BLEQ _max
    BL _reg_dump
    MOV PC, R4
    
_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return

_add:
    ADD R0, R2,R3
    MOV PC, LR

_sub:
    SUB R0, R2, R3          @ subtract R2 from R1 and store the value in R0
    MOV PC, LR              @ return

_mul:
    MUL R0, R2, R3          @ multiply R1 and R2 and store the value in R0
    MOV PC, LR              @ return
_max:
    CMP R2, R3              @ compare R1 and R2 
    MOVGT R0, R2            @ Move Greater Than
    MOVLT R0, R3            @ Move Less Than
    MOV PC, LR              @ return

.data
format_str:     .asciz      "%d"
read_char:	.asciz	    ""
printf_str:     .asciz      "The number entered was: %d\n"
Printf_Output:  .asciz	    "The output based on the entered operation code is : %d\n"
