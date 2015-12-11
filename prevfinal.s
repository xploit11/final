/******************************************************************************
* @FILE exam_template.s
* @BRIEF code template for CSE 2312 final exam
*
* Program prompts the user for 10 postive integers, then computes and prints 
* the sum, minimum, and maximum values before terminating.
*
* @AUTHOR Christopher D. McMurrough
******************************************************************************/
 
    .global main
    .func main
 
main:    
    BL  _print_name     @ print programmer name
    BL  _print_prompt   @ print user prompt
    MOV R0, #0
    BL  _writeloop      @ retrieve 10 user input values
    BL _arrayprint
    #BL  _calc_result    @ compute the sum, min, and max of the top 10 values on the stack
    #BL  _print_result   @ print print result
    B   _exit           @ branch to exit procedure with no return
 
 _printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
 
 _print_name:
    PUSH {LR}            @ store LR since printf call overwrites
    LDR R0,=name_str     @ R0 contains formatted string address
    BL printf            @ call printf
    POP {PC}             @ return
 
 _print_prompt:
    PUSH {LR}            @ store LR since printf call overwrites
    LDR R0,=prompt_str   @ R0 contains formatted string address
    BL printf            @ call printf
    POP {PC}             @ return
 
_writeloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
    PUSH {R0}
    BL _scanf            @ get a number from console
    MOV R9, R0
    POP {R0}
    LDR R1, =a_array        @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    STR R2, [R9]            @ write the address of a[i] to a[i]
    ADD R0, R0, #1          @ increment index
    B   _writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #0              @ initialze index variable

_calc_result:
    MOV R5, #0           @ initialize loop counter
    POP {R1}             @ remove a value from the stack
    MOV R8, R1           @ store R1 value in R8
    MOV R9, R1           @ store R1 value in R9
    ADD R7, R7, R1       @ add R7 and R1 and store in R7
    LDR R1, =a_array        @ get address of a
    _loop2: 
            POP {R1}             @ remove a value from the stack
            ADD R7, R7, R1       @ add R7 and R1 and store in R7
            CMP R1, R8           @ compare R1 and R8
            MOVLT R8, R1         @ if R1 < R8 then update R8 with R1 value
            CMP R1, R9           @ compare R1 and R9
            MOVGT R9, R1         @ if R1 < R9 then update R9 with R1 value
            ADD R5, R5, #1       @ increment loop counter
            CMP R5, #9          @ check for end of loop
            BNE _loop2           @ loop if necessary
    MOV PC, LR          @ return
 
_arrayprint:
    CMP R0, #10             @ check to see if we are done iterating
    BEQ arrayprintdone            @ exit loop if done
    LDR R7, =a_array        @ get address of a(put b for array a)
    LSL R2, R0, #2          @ multiply index*4 to get array offset /////OFFSET TOO STORE STH TO B SAME
    ADD R2, R7, R2          @ R2 now has the element address //CHANGE TO ADDRESS OF B TWO REQUIRED 
    LDR R1, [R2]
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B _arrayprint           @ branch to next loop iteration
arrayprintdone:
    B _exit


 _print_result:
    PUSH {LR}           @ store LR since printf call overwrites
    MOV R1, R7          @ move stored sum to R7 for printing
    MOV R2, R8          @ move stored sum to R8 for printing
    MOV R3, R9          @ move stored sum to R9 for printing
    LDR R0,=result_str  @ R0 contains formatted string address
    BL printf           @ call printf
    POP {PC}            @ return
 
_exit:  
    MOV R7, #4          @ write syscall, 4
    MOV R0, #1          @ output stream to monitor, 1
    MOV R2, #21         @ print string length
    LDR R1,=exit_str    @ string at label exit_str:
    SWI 0               @ execute syscall
    MOV R7, #1          @ terminate syscall, 1
    SWI 0               @ execute syscall
 
_scanf:
    PUSH {LR}               @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                @ return
 
.data
.balign 4
a_array:    .skip   40
name_str:   .asciz  "Anish Timila: 1000929208 \n"
prompt_str: .asciz  "Please enter 10 positive integers: \n"
format_str: .asciz  "%d"
printf_str: .asciz  "array_a[%d] = %d"
#result_str: .asciz  "Sum: %10d     Min: %10d     Max: %10d \n"
exit_str:   .ascii  "Terminating program.\n"
