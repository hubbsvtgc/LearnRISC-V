/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

/*
Normal Boot Sequence in board if NOT interrupted.

Reset Vector ROM
0x1000: Holds MSEL "pins", value of 0x3 (pins are NOT bonded out)
0x1004: BOOT ENTRY POINT IS HERE:
0x1004:    auipc t0, 0         // load t0 with PC (t0 = 0x1004)
0x1008:    lw t1, -4(t0)       // load t1 with MSEL (t0 = 0x3, fixed)
0x100c:    slli t1, t1, 0x3    // shift t1 left by 3. (t1 = 0x18)
0x1010:    add t0, t0, t1      // t0 = t0 + t1 (t0 = 0x101C)
0x1014:    lw t0, 252(t0)      // load t0 with value at 0x101C (t0 = 0x10000)
0x1018:    jr t0               // jump to memory mapped Mask ROM ......

0x10000:
memory mapped Mask ROM (jumps to memory mapped OTP)
    00010000: 0x732540f1   csrr    a0,mhartid               // a0 = 0
    00010004: 0x97050000   auipc   a1,0x0                   // a1 = 0x10004
    00010008: 0x93854505   addi    a1,a1,84 # 0x10058       // a1 = 0x10058
    0001000c: 0xb7020200   lui     t0,0x20                  // t0 = 0x20000
    00010010: 0x67800200   jr      t0 # 0x20000             // jump to 0x20000, memory mapped OTP

0x20000:
memory mapped OTP
Run low level init and jump to QSPI location 0x20010000
*/

/* Right now, this is code is a way to be loaded into RAM and
undergo controlled execution through gdb.
Default clock set speed is 13.8 Mhz */

.section .code

.global _start

_start:

addi t0, x0, 3; 
addi t1, x0, 5;

loop_forever:
jal x0, loop_forever;


