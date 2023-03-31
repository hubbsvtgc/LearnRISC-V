
/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.include "inc/macros.inc";
.include "inc/mmap.inc";
.include "inc/clint.inc";
.include "inc/csr.inc";

.equiv MASK_MPP_USER_MODE, 0xFFFFE7FF
.equiv PMP_REG0_TOR, 0x80000800

.equiv PMP_REG1_NAPOT, 0x80001000 /* base address to test pmp */

.globl app_entry;

.section .text

Lalign4 enter_user_mode:

    nop;
    li t0, 2;
    li t1, 3;
    add t0, t0, t1;

    li t0, PMP_REG1_NAPOT;
    addi t0, t0, 4;
    lw t1, 0(t0);

    sw t1, 0(t0);

    nop;
j .

Lalign4 app_entry:

    # Hart is now in machine mode

    # mstatus        0x1800   
    # SD:0 VM:00 MXR:0 PUM:0 MPRV:0 
    # XS:0 FS:0 MPP:3 HPP:0 SPP:0 MPIE:0 HPIE:0 SPIE:0 UPIE:0 MIE:0 HIE:0 SIE:0 UIE:0

    csrr t0, mstatus;

    li t1, MASK_MPP_USER_MODE;
    and t0, t0, t1; # Set MPP to user mode
    or t0, t0, 8; # set MIE
    csrw mstatus, t0;

    la t0, enter_user_mode;
    csrw mepc, t0; # Set user mode entry address

    # TOR upto 0x80000800
    li t0, PMP_REG0_TOR;
    srli t0, t0, 2;
    csrw pmpaddr0, t0;

    # 32 Bytes NAPOT from 0x80001000
    li t0, PMP_REG1_NAPOT;
    srli t0, t0, 2;
    ori t0, t0, 3;
    csrw pmpaddr1, t0; 

    li t0, 0x0707190F; #li t0, 0x0707180F;
    csrw pmpcfg0, t0;

    mret;
