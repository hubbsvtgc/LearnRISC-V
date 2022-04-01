/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.global _trap_routine;

/* Trap vector base address should be aligned on 4-byte boundary */
_trap_routine:
    nop;
    csrr t0, mcause;
    mret;
