/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

/*
https://forums.sifive.com/t/how-to-modify-msel-pin-state/5542

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
As shipped, the OTP memory at the boot location is preprogrammed to
jump immediately to the end of the OTP memory, which contains the
following code to jump to the beginning of the SPI-Flash at 0x2000 0000:

fence 0,0
li t0, 0x20000000
jr t0

fence 0,0 is encoded as 0x0000 000F, and the instruction
may be modified by burning additional bits to transform
it into a JAL instruction ( opcode 0x6F ) to execute arbitrary
code rather than jumping directly to the beginning of the SPI-Flash.

Thus, at power-up, program execution will jump essentially jump to 0x2000_0000,

Right now, this is code in a way to be loaded into RAM and
undergo controlled execution through gdb. */

.include "inc/config.inc"  /** Build Configuration */
.include "inc/macros.inc"  /** Assembly macros */

.extern linker_stack_start; /* From linker script */
.globl _start_entry; /* To be visible to linker */
.extern trap_base;

.section .start_entry

Lalign4 _start_entry:

    /* set stack pointer */

    lui sp, %hi(linker_stack_start);
    addi sp, sp, %lo(linker_stack_start);

    /* set trap vector base with vector mode */

    lui t0, %hi(trap_base);
    addi t0, t0, %lo(trap_base);

.ifdef INTERRUPT_VECTOR_MODE
    ori t0, t0, 1;
.endif

    csrw mtvec, t0;

    /* disable all interrupts */

    # csrw mstatus, zero;
    csrw mie, zero;

    j app_entry; /* Should this be a jump or call? - entry point for app */

j .
