    .text
    .align 2
    .global main
main:
    stmfd sp!, {r0-r8, lr}
    add r4, r1, #4  @point to first character of target
    @check whether the variable is negative or not
    ldr r1, [r4]    
    ldrb r0, [r1]
    cmp r0, #78
    mov r7, #0
    moveq r7, #1    @if r7 is 1 means target is negative
    ldr r0, [r4]
    addeq r0, r0, #1
    bl strtol
    mov r8, r0  @r8 store the integer
    mov r1, r8
    cmp r7, #1
    ldreq r0, =negformat
    ldrne r0, =format
    bl printf    

    mov r6, #31
exponent:
    mov r1, r8, lsr #31
    cmp r1, #1
    mov r8, r8, lsl #1
    beq printexp
    cmp r6, #0
    beq printexp
    sub r6, r6, #1
    b exponent

printexp:
    add r6, r6, #127
    mov r6, r6, lsl #24
    mov r4, #0
loop1:
    cmp r4, #8
    beq fraction
    add r4, r4, #1
    mov r1, r6, lsr #31
    ldr r0, =number
    bl printf
    mov r6, r6, lsl #1
    b loop1

fraction:
    mov r4, #0
loop2:
    cmp r4, #23
    beq theEnd
    mov r1, r8, lsr #31
    ldr r0, =number
    bl printf
    add r4, r4, #1
    mov r8, r8, lsl #1
    b loop2

theEnd:
    ldr r0, =finish
    bl printf
    ldmfd sp!, {r0-r8, lr}
    bx lr
format:
    .ascii "%d is code by 0\0"
negformat:
    .ascii "-%d is code by 1\0"
number:
    .ascii "%d\0"
finish:
    .ascii "\n\0"
