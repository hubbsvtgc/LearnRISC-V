/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
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

Lalign4 delay: /* value passed in a0 */

Lalign4 delayloop_start:

    beqz a0, delayloop_end;
    addi a0, a0, -1;
    j delayloop_start;

Lalign4 delayloop_end:
ret;

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

    /* delay */
    li a0, 0xfffff;
    call delay;

    /* LED off */
    li a0, GPIO21;
    call gpio_set_high;

    /* delay */
    li a0, 0xfffff;
    call delay;

j forever_loop;
