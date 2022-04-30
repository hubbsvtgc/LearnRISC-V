/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.global FN_trap_routine;

.section .text

/* Trap vector base address should be aligned on 4-byte boundary */
FN_trap_routine:
    nop;
    csrr t0, mcause;

    /* Interrupt Exception code
     * 3 - Machine Software Interrupt
     * 7 - Machine timer interrupt
     * 11- Machine external interrupt
     */
LB_trap_routine_end:
j LB_trap_routine_end; /* Just loop around until we know to handle it */

/* A0 reg's LSbit has the mode
 * 0 - Direct
 * 1 - Vectored */

FN_trap_set_mode:

    andi a0, a0, 1;
    slt t0, zero, a0;

    csrr t1, mtvec;
    or t1, t1, t0;
    csrw mtvec, t1;
ret;
