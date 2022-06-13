/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.global FN_trap_routine;

.section .text

.equiv INTERRUPT_MASK, 0x80000000
.equiv EXCEPTION_CODE_MASK, 0x7FFFFFFF
.equiv EXT_INTR_BIT, 0x8
.equiv MACHINE_SI_MASK, 0x3
.equiv MACHINE_TI_MASK, 0x7
.equiv MACHINE_EI_MASK, 0xb

.include "fe310_g002_mmap_h.S"  /** FE310 Mmap */
.include "RV_PLIC.S" /** From RISC-V Spec */

.p2align 2

/* Trap vector base address should be aligned on 4-byte boundary 
 * this dont take any argument */

FN_trap_routine:
    nop;
    csrr t0, mcause;

    /* HACK: only for gpio21 interrupt */
    li a0, 0x00200000;
    call FN_gpio_clear_rise_pend; 

    li t1, FE310_PLICMMAP_BASE;
    li t2, PLIC_CLAIMCOMP_CTX1_OFFSET;

    add t1, t2, t1;

    lw t2, 0(t1);

    sw t2, 0(t1);

mret; /* NOTE: it should be MRET */



