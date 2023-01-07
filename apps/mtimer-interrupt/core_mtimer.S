
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";
.include "inc/mmap.inc";
.include "inc/clint.inc";

/* Mtimer is counted by rtclk, which is 32.768 khz */

.equiv ONE_SEC, 0x8000 /* 32768 in hex */
.equiv FIVE_SEC, 0x28000 /* 32768 * 5 in hex */
.equiv ONE_MIN, 0x1E0000 /* 32768 * 60 in hex */

.globl app_entry;
.globl timer_m_apphandler;

Lalign4 app_entry:
    nop;
    nop;

    call intr_enable_mtimer;

    /* Clear mtime */

    li t0, CLINT_BASE;
    li t1, MTIME_OFF; 
    add t0, t0, t1;
    sw zero, 0(t0);
    sw zero, 4(t0); /* 64 bit register */

    /* Set timer interrupt duration */

    li t0, CLINT_BASE;
    li t1, MTIMECMP_OFF; 
    add t0, t0, t1;

    li t2, FIVE_SEC;
    sw t2, 0(t0);
    sw zero, 4(t0); /* 64 bits register */

    j . 

timer_m_apphandler:
    nop;
mret;

