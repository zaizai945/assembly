    .text
    .align 2
    .global main
main:
    stmfd sp!, {r0-r8, fp, lr}
    bl start_deasm
    .include "test.s"
start_deasm:
    adr r8, start_deasm
    mov r4, lr  @r4 point to current instruction
    mov r7, lr  @r7 point to test.s
    ldr r0, =title
    bl printf
    b loop
loop:
    @program counter
    sub r1, r4, r7

    @condition
    ldr r0, [r4]
    mov r0, r0, lsr #28 @[31:28] bit

    cmp r0, #0
    ldreq r2, =condition_EQ
    cmp r0, #1
    ldreq r2, =condition_NE
    cmp r0, #2
    ldreq r2, =condition_CS
    cmp r0, #3
    ldreq r2, =condition_CC
    cmp r0, #4
    ldreq r2, =condition_MI
    cmp r0, #5
    ldreq r2, =condition_PL
    cmp r0, #6
    ldreq r2, =condition_VS
    cmp r0, #7
    ldreq r2, =condition_VC
    cmp r0, #8
    ldreq r2, =condition_HI
    cmp r0, #9
    ldreq r2, =condition_LS
    cmp r0, #10
    ldreq r2, =condition_GE
    cmp r0, #11
    ldreq r2, =condition_LT
    cmp r0, #12
    ldreq r2, =condition_GT
    cmp r0, #13
    ldreq r2, =condition_LE
    cmp r0, #14
    ldreq r2, =condition_AL

    @classify instruction type
    ldr r0, [r4]
    and r0, r0, #0x0C000000 @[27:26] bit
    mov r0, r0, lsr #26
    cmp r0, #0
    beq data_process
    cmp r0, #1
    beq data_move
    cmp r0, #2
    beq branch_link
    b undefined
data_process:
    ldr r0, [r4]
    and r0, r0, #0x0E000000 @[27:25] bit
    mov r0, r0, lsr #25
    cmp r0, #1
    beq process
    ldr r0, [r4]
    and r0, r0, #0x00000090 @[7] and [4] bit
    mov r0, r0, lsr #4
    cmp r0, #9
    beq undefined
    b process
process:
    ldr r0, [r4]
    and r0, r0, #0x01E00000 @[24:21] bit
    mov r0, r0, lsr #21
    cmp r0, #0
    ldreq r3, =instruction_AND
    cmp r0, #1
    ldreq r3, =instruction_EOR
    cmp r0, #2
    ldreq r3, =instruction_SUB
    cmp r0, #3
    ldreq r3, =instruction_RSB
    cmp r0, #4
    ldreq r3, =instruction_ADD
    cmp r0, #5
    ldreq r3, =instruction_ADC
    cmp r0, #6
    ldreq r3, =instruction_SBC
    cmp r0, #7
    ldreq r3, =instruction_RSC
    cmp r0, #8
    ldreq r3, =instruction_TST
    cmp r0, #9
    ldreq r3, =instruction_TEQ
    cmp r0, #10
    ldreq r3, =instruction_CMP
    cmp r0, #11
    ldreq r3, =instruction_CMN
    cmp r0, #12
    ldreq r3, =instruction_ORR
    cmp r0, #13
    ldreq r3, =instruction_MOV
    cmp r0, #14
    ldreq r3, =instruction_BIC
    cmp r0, #15
    ldreq r3, =instruction_MVN
    b print
data_move:
    ldr r0, [r4]
    and r0, r0, #0x0E000000
    mov r0, r0, lsr #25
    cmp r0, #2
    beq move
    ldr r0, [r4]
    and r0, r0, #0x00000010
    mov r0, r0, lsr #4
    cmp r0, #1
    beq undefined
    b move
move:
    ldr r0, [r4]
    and r0, r0, #0x00500000
    mov r0, r0, lsr #20
    cmp r0, #0
    ldreq r3, =instruction_STR
    cmp r0, #1
    ldreq r3, =instruction_LDR
    cmp r0, #4
    ldreq r3, =instruction_STRB
    cmp r0, #5
    ldreq r3, =instruction_LDRB
    b print
branch_link:
    ldr r0, [r4]
    and r0, r0, #0x0A000000
    mov r0, r0, lsr #25
    cmp r0, #4
    beq undefined
    ldr r0, [r4]
    and r0, r0, #0x01000000
    mov r0, r0, lsr #24
    cmp r0, #0
    ldreq r3, =instruction_B
    cmp r0, #1
    ldreq r3, =instruction_BL
    b print
undefined:
    ldreq r3, =instruction_UND
    b print
print:
    ldr r0, =format
    bl printf

    add r4, r4, #4
    cmp r4, r8
    bne loop
    beq exit
exit:
    ldmfd sp!, {r0-r8, fp, lr}
    bx lr
title:
    .ascii "pc\tcondition\tinstruction\n\0"

format:
    .ascii "%d\t%s\t\t%s\n\0"

condition_EQ:
    .ascii "EQ\0"
condition_NE:
    .ascii "NE\0"
condition_CS:
    .ascii "CS/HS\0"
condition_CC:
    .ascii "CC/LO\0"
condition_MI:
    .ascii "MI\0"
condition_PL:
    .ascii "PL\0"
condition_VS:
    .ascii "VS\0"
condition_VC:
    .ascii "VC\0"
condition_HI:
    .ascii "HI\0"
condition_LS:
    .ascii "LS\0"
condition_GE:
    .ascii "GE\0"
condition_LT:
    .ascii "LT\0"
condition_GT:
    .ascii "GT\0"
condition_LE:
    .ascii "LE\0"
condition_AL:
    .ascii "AL\0"

instruction_UND:
    .ascii "UND\0"
instruction_AND:
    .ascii "AND\0"
instruction_EOR:
    .ascii "EOR\0"
instruction_SUB:
    .ascii "SUB\0"
instruction_RSB:
    .ascii "RSB\0"
instruction_ADD:
    .ascii "ADD\0"
instruction_ADC:
    .ascii "ADC\0"
instruction_SBC:
    .ascii "SBC\0"
instruction_RSC:
    .ascii "RSC\0"
instruction_TST:
    .ascii "TST\0"
instruction_TEQ:
    .ascii "TEQ\0"
instruction_CMP:
    .ascii "CMP\0"
instruction_CMN:
    .ascii "CMN\0"
instruction_ORR:
    .ascii "ORR\0"
instruction_MOV:
    .ascii "MOV\0"
instruction_BIC:
    .ascii "BIC\0"
instruction_MVN:
    .ascii "MVN\0"
instruction_STR:
    .ascii "STR\0"
instruction_LDR:
    .ascii "LDR\0"
instruction_STRB:
    .ascii "STRB\0"
instruction_LDRB:
    .ascii "LDRB\0"
instruction_B:
    .ascii "B\0"	
instruction_BL:
    .ascii "BL\0"
