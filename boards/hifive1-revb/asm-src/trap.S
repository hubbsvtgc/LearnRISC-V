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

.p2align 2

/* Trap vector base address should be aligned on 4-byte boundary 
 * this dont take any argument */

FN_trap_routine:
    nop;
    csrr t0, mcause;

    li t1, EXCEPTION_CODE_MASK;
    and a0, t0, t1; /* Extract the exception code */

    srli t1, t0, 31;
    beqz t1, LB_TRAP_exception;

        call FN_trap_interrupt;
        j LB_trap_routine_end;

    LB_trap_exception:

        call FN_trap_excetption;

LB_trap_routine_end:
ret;

/* Function to set trap mode, direct or vectored */

FN_trap_set_mode:

    /* A0 reg's LSbit has the mode
     * 0 - Direct
     * 1 - Vectored */

    andi a0, a0, 1;
    slt t0, zero, a0;

    csrr t1, mtvec;
    or t1, t1, t0;
    csrw mtvec, t1;
ret;

/* Handle Interrupt exception codes.
 * a0 has the exception code */

FN_trap_interrupt:


        /* Interrupt Exception code
        * 0 - 3  Software Interrupt
        * 4 - 7  Timer interrupt
        * 8 - 11 External interrupt */

    srli t1, t0, 2;
    seqz t1, t1; /* software interrupt */

    slti t1, t0, 8;

ret;

/* Handle exception, exception codes.
 * a0 has the exception code */

FN_trap_exception:


ret;