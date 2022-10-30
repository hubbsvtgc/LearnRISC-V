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
.equiv RUN, 1

Lalign4 app_entry:

  /* Disable interrupt */
  csrw mie, 0;

  /* Configure pin 21 as gpio */
   li a0, GPIO21;
  call gpio_set_as_gpio;

  li a0, GPIO21;
  call gpio_set_as_output;

.ifdef TEST
Lalign4 control_gpio21:

      /* LED off */
    li a0, GPIO21;
    call gpio_set_high;

    nop;
    nop;

    /* LED on */
    li a0, GPIO21;
    call gpio_set_low;

  j control_gpio21;
.endif

.ifdef RUN
Lalign4 control_gpio21:

    /* LED off */
    li a0, GPIO21;
    call gpio_set_high;

    /* delay */
    li a0, 0xffffff;


    Lalign4 LB_delayloop_start:

      beqz a0, LB_delayloop_end;
      addi a0, a0, -1;
      j LB_delayloop_start;
  
    Lalign4 LB_delayloop_end:

    /* LED on */
    li a0, GPIO21;
    call gpio_set_low;

    /* delay 2 */
    li a0, 0xffffff;

    Lalign4 LB_delayloop2_start:

      beqz a0, LB_delayloop2_end;
      addi a0, a0, -1;
      j LB_delayloop2_start;
  
    Lalign4 LB_delayloop2_end:

  j control_gpio21;

ret;

.endif

Lalign4 _app_entry_end:
