
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
.equiv PMP_REG0, 0x90000000

.globl app_entry;

.section .text

Lalign4 enter_user_mode:

    nop;
    li t0, 2;
    li t1, 3;
    add t0, t0, t1;

    la t0, 0x0;
    csrw mie, t0; # Set user mode entry address

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

#    li t0, PMP_REG0;
#    srli t0, t0, 2;
#    csrw pmpaddr0, t0;

#    li t0, 0x0707070F;
#    csrw pmpcfg0, t0;

    mret;
