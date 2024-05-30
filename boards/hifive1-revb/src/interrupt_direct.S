/****************************************************************************
 *
 *   Copyright (C) 2024 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.include "inc/config.inc"  /** Build Configuration */

.ifdef INTERRUPT_DIRECT_MODE

.include "inc/macros.inc"  /** Assembly macros */

.globl trap_base;

Lalign64 trap_base:

    /* mscratch register is dedicated only for machine mode 
     * mscratch has the address of trap frame 
     * lets swap with sp register. CSRRW (Atomic read/write csr)
     * trap switches to machine mode */
    
    /* swap - csrrw rd, csr, rs1 */
    csrrw sp, mscratch, sp 

    addi sp, sp, -124 /* 31 registers each of a word */

    /* STORE all registers */

    sw ra, 0(sp) /* x1 */
    csrr ra, mscratch /* sp -> mscratch -> ra */
    sw ra, 4(sp)  /* x2/sp */
    sw gp, 8(sp) /* x3 */
    sw tp, 12(tp) /* x4 */

    sw t0, 16(sp) /* x5 */
    sw t1, 20(sp) /* x6 */
    sw t2, 24(sp) /* x7 */

    sw s0, 28(sp) /* X8 */
    sw s1, 32(sp) /* x9 */

    sw a0, 36(sp) /* x10 */
    sw a1, 40(sp) /* x11 */
    sw a2, 44(sp) /* x12 */
    sw a3, 48(sp) /* x13 */
    sw a4, 52(sp) /* x14 */
    sw a5, 56(sp) /* x15 */
    sw a6, 60(sp) /* x16 */
    sw a7, 64(sp) /* x17 */

    sw s2, 68(sp) /* x18 */
    sw s3, 72(sp) /* x19 */
    sw s4, 76(sp) /* x20 */
    sw s5, 80(sp) /* x21 */
    sw s6, 84(sp) /* x22 */
    sw s7, 88(sp) /* x23 */
    sw s8, 92(sp) /* x24 */
    sw s9, 96(sp) /* x25 */
    sw s10, 100(sp) /* x26 */
    sw s11, 104(sp) /* x27 */

    sw t3, 108(sp) /* x28 */
    sw t4, 112(sp) /* x29 */
    sw t5, 116(sp) /* x30 */
    sw t6, 120(sp) /* x31 */

    csrrw sp, mscratch, sp /* swap back, mscratch has trap frame end, sp has original value */

    /****************************
     Handle interrupts
     ****************************/

    /* RESTORE */

    csrrw sp, mscratch, sp /* After this sp should be trap frame start - 124 */
    
    lw ra, 0(sp) /* x1 */
    lw sp, 4(sp)  /* X2/sp -  in mscratch */
    lw gp, 8(sp) /* x3 */
    lw tp, 12(tp) /* x4 */

    lw t0, 16(sp) /* x5 */
    lw t1, 20(sp) /* x6 */
    lw t2, 24(sp) /* x7 */

    lw s0, 28(sp) /* X8 */
    lw s1, 32(sp) /* x9 */

    lw a0, 36(sp) /* x10 */
    lw a1, 40(sp) /* x11 */
    lw a2, 44(sp) /* x12 */
    lw a3, 48(sp) /* x13 */
    lw a4, 52(sp) /* x14 */
    lw a5, 56(sp) /* x15 */
    lw a6, 60(sp) /* x16 */
    lw a7, 64(sp) /* x17 */

    lw s2, 68(sp) /* x18 */
    lw s3, 72(sp) /* x19 */
    lw s4, 76(sp) /* x20 */
    lw s5, 80(sp) /* x21 */
    lw s6, 84(sp) /* x22 */
    lw s7, 88(sp) /* x23 */
    lw s8, 92(sp) /* x24 */
    lw s9, 96(sp) /* x25 */
    lw s10, 100(sp) /* x26 */
    lw s11, 104(sp) /* x27 */

    lw t3, 108(sp) /* x28 */
    lw t4, 112(sp) /* x29 */
    lw t5, 116(sp) /* x30 */
    lw t6, 120(sp) /* x31 */

    addi sp, sp, 124
    csrw mscratch, sp

mret /* will return with mepc */

.endif

