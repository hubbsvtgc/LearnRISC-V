/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

 /* GPIO 19 - Green,
  * GPIO 21 - Blue,
  * GPIO 22 - Red,
  * on the board schematics */

.section .text

.include "inc/macros.inc";
.include "inc/gpio.inc";

.globl blink_init;

.equiv GPIO21_BPOS_ON, 0x00100000
.equiv GPIO21_BPOS_OFF,0xFF7FFFFF

Lalign4 blink_init:

    addi sp, sp, -4;
    sw ra, 0(sp);

    /* Configure pin 21 as gpio */
    li a0, GPIO21;
    call gpio_set_as_gpio;

    /* LED off */
    li a0, GPIO21;
    call gpio_set_high;

    li a0, GPIO21;
    call gpio_set_as_output;

    lw ra, 0(sp);
    addi sp, sp, 4;
ret;

nop;
Lalign4 blink_loop:

    /* LED on, since pulled high */
    li a0, GPIO21_BPOS_OFF;
    li t0, GPIO_BASE;
    lw t1, GPIO_OUT_VALUE_OFF(t0);
    and a0, t1, a0;
    sw a0, GPIO_OUT_VALUE_OFF(t0);

    /* LED ON delay */
    li t0, 0xfffff;

Lalign4 ondelayloop_start:
    beqz t0, ondelayloop_end;
    addi t0, t0, -1;
    j ondelayloop_start;
Lalign4 ondelayloop_end:

    /* LED off */
    li a0, GPIO21_BPOS_ON;

    li t0, GPIO_BASE;
    lw t1, GPIO_OUT_VALUE_OFF(t0);
    or a0, t1, a0;
    sw a0, GPIO_OUT_VALUE_OFF(t0);

    /* LED off delay */
    li t0, 0xfffff;

Lalign4 offdelayloop_start:
    beqz t0, offdelayloop_end;
    addi t0, t0, -1;
    j offdelayloop_start;
Lalign4 offdelayloop_end:
    nop;

j blink_loop;

