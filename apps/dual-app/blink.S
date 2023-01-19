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

.globl app_entry;

.equiv GPIO21, 21

Lalign4 app_entry:

  /* Disable interrupt */
  csrw mie, 0;

  /* Configure pin 21 as gpio */
   li a0, GPIO21;
  call gpio_set_as_gpio;

  /* LED off */
  li a0, GPIO21;
  call gpio_set_high;

  li a0, GPIO21;
  call gpio_set_as_output;

Lalign4 forever_loop:

    /* LED on, since pulled high */
    li a0, GPIO21;
    call gpio_set_low;

    /* LED ON delay */
    li t0, 0xfffff;
Lalign4 ondelayloop_start:
    beqz t0, ondelayloop_end;
    addi t0, t0, -1;
    j delayloop_start;
Lalign4 ondelayloop_end:

    /* LED off */
    li a0, GPIO21;
    call gpio_set_high;

    /* LED off delay */
    li t0, 0xfffff;
Lalign4 offdelayloop_start:
    beqz t0, delayloop_end;
    addi t0, t0, -1;
    j offdelayloop_start;
Lalign4 offdelayloop_end:

j forever_loop;
