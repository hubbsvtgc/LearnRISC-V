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

    li t0, FE310_PLICMMAP_BASE;
    li t1, PLIC_CLAIMCOMP_CTX1_OFFSET;
    add t0, t1, t0; /* t0 has the claim/comp reg addr */

    lw t1, 0(t0);
    addi t1, t1, 63; /* Interrupt source in t1 */

    li t2, 4;
    beq t2, t1, LB_uart1_intr;

    /* HACK: if not uart1, for gpio21 interrupt */
    j LB_gpio21_intr;

.p2align 2
LB_uart1_intr: /* Uart1 interrupt */

    j LB_trap_routine_end;

.p2align 2
LB_gpio21_intr: /* Gpio21 interrupt */

    li a0, 0x00200000;
    call FN_gpio_clear_rise_pend;

.p2align 2
LB_trap_routine_end:
    sw t2, 0(t0); /* Write with any value means completion */

mret; /* NOTE: it should be MRET */



