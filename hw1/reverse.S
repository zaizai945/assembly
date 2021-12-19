    .text
    .align 2
    .global main
main:
    stmfd   sp!, {r0, r1, r4, lr}       @存進stack中，且stack pointer會指向r0
    add     r4, sp, #4                  @將r4指向r1
    sub     sp, sp, #4                  @stakc pointer往下移等一下這個位置會用來存放要印的字元的位置
    mov     r3, r1
    add     r3, r3, #4
    ldr     r3, [r3]
    mov     r0, r3
    bl      strlen                      @得到要印出來的字串的長度會放在r0
    sub     r0, r0, #1                  @從字串的尾巴開始
    str     r0, [sp]                    @存到stack pointer 所指到的位置
    b       .Loop
.Loop:
    @確認是否印完字串
    ldr     r3, [sp]
    cmp     r3, #0
    blt     .Exit
    
    @r3->字串的address
    ldr     r3, [r4]
    add     r3, r3, #4
    
    @r3->要印出的字元的address
    ldr     r2, [r3]
    ldr     r3, [sp]
    add     r3, r2, r3
    
    ldrb    r3, [r3] 
    mov     r0, r3

    @轉成小寫並輸出
    bl      tolower
    bl      putchar
    
    @指向前一個字元
    ldr     r3, [sp]
    sub     r3, r3, #1
    str     r3, [sp]
    b      .Loop
.Exit:
    add     sp, sp, #4
    ldmfd   sp!, {r0, r1, r4, lr}
    bx lr