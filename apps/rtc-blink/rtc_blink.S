/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";
.include "inc/mmap.inc";
.include "inc/clint.inc";
.include "inc/csr.inc";
.include "inc/rtc.inc";

 /* GPIO 19 - Green,
  * GPIO 21 - Blue,
  * GPIO 22 - Red,
  * on the board schematics */

.globl app_entry;

.equiv GPIO21, 21


Lalign4 app_entry:

  /* Disable interrupt */
  csrw mie, 0;

  /*  RTC settings */

   /* rtccfg (offset 0x040) */
  li t0, AON_BASE;

  /* disable lf osc */
  lw t1, LF_OSCCFG_OFST(t0);
  addi t2, zero, 1
  slli t2, t2, 30
  not t2, t2;
  and t1, t1, t2;
  sw t1, LF_OSCCFG_OFST(t0);

  /* sel 32.768 khz clock for lf */
  lw t1, LF_EXTCLK_SEL_OFST(t0);
  ori t1, t1, 1;
  sw t1, LF_EXTCLK_SEL_OFST(t0);

  /* init rtc high & low to 0 */
  sw zero, RTC_COUNT_HI_OFST(t0);
  sw zero, RTC_COUNT_LO_OFST(t0);
  sw zero, RTC_COMP_OFST(t0);

  /* Enable rtc with scale val 15 */
  li t1, 0x100F; 
  sw t1, RTC_CFG_OFST(t0);

  /* read rtccounthi (offset 0x04C) - high bits counter */
  lw t2, RTC_COUNT_HI_OFST(t0);

  /* read rtccountlo (offset 0x048) - low bits counter */
  lw t3, RTC_COUNT_LO_OFST(t0);

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

    /* 5sdelay */

    li t0, AON_BASE;
    li a1, 5;

    sw zero, RTC_COUNT_HI_OFST(t0);
    sw zero, RTC_COUNT_LO_OFST(t0);
    sw zero, RTC_COMP_OFST(t0);

    sw a1, RTC_COMP_OFST(t0);

wait_to_expire1:
    nop;
    lw a1, RTC_CFG_OFST(t0);
    addi t1, zero, 1;
    slli t1, t1, 28 # 0x10000000 - rtcip0 bit[28]
    and a1, a1, t1;
    beqz a1, wait_to_expire1;

    sw zero, RTC_COMP_OFST(t0);
    
    /* LED off */
    li a0, GPIO21;
    call gpio_set_high;

    /* 5sdelay */

    li t0, AON_BASE;
    li a1, 5;

    sw zero, RTC_COUNT_HI_OFST(t0);
    sw zero, RTC_COUNT_LO_OFST(t0);
    sw zero, RTC_COMP_OFST(t0);

    sw a1, RTC_COMP_OFST(t0);

wait_to_expire2:
    nop;
    lw a1, RTC_CFG_OFST(t0);
    addi t1, zero, 1;
    slli t1, t1, 28 # 0x10000000 - rtcip0 bit[28]
    and a1, a1, t1;
    beqz a1, wait_to_expire2;
    sw zero, RTC_COMP_OFST(t0);

j forever_loop;
