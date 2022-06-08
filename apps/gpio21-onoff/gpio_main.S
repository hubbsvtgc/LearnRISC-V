/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

 /* GPIO 19, 21 & 22 are connected to Green, Blue & Red LED correspondingly
  * on the board schematics */

.section .text
.global FN_app_entry;

.equiv GPIO21_BIT_POSITION, 0x00200000
.equiv GPIO21_INTERRUPT_SRC, 29

.equiv AONRTC_INTERRUPT_SRC, 2

.p2align 2

 FN_app_entry:

   /* Set all interrupt sources to priority 2 */

  li a0, 52; /* Max source id */
  li a1, 2; /* Prority */

.p2align 2
  LB_apploop_start:

    beqz a0, LB_apploop_end;

    sw a0, 0(sp);
    sw a1, 4(sp);

    call FN_plic_set_priority;

    lw a0, 0(sp);
    lw a1, 4(sp);

    addi a0, a0, -1;
    j LB_apploop_start;
  
.p2align 2
  LB_apploop_end:

  /* Clear gpio 21 rise intr pend */
  li a0, GPIO21_BIT_POSITION;
  call FN_gpio_clear_rise_pend;

  /* Set priority 3 to gpio interrupt source 29 */
  li a0, GPIO21_INTERRUPT_SRC;
  li a1, 3;
  call FN_plic_set_priority;

  li a1, 2; /* All interrupts upto priority 2 would be masked */
  call FN_plic_set_threshold;

  /* Enable external interrupt */
  call FN_intr_enable_mexternal; 

  /* set source enable bits in PLIC */
  li a0, GPIO21_INTERRUPT_SRC;
  call FN_plic_enable_src;

  /* Configure pin 29 as both input (to sense) & output */
  li a0, GPIO21_BIT_POSITION;
  call FN_gpio_configure_as_input;

  li a0, GPIO21_BIT_POSITION;
  call FN_gpio_configure_as_output;

  li a0, GPIO21_BIT_POSITION;
  call FN_gpio_enable_rise_intr;

.p2align 2
  control_gpio21:

    /* set 1 */
    li a0, GPIO21_BIT_POSITION;
    call FN_gpio_write_value;

    /* delay */
    li a0, 0xffffff; 

    .p2align 2
    LB_delayloop_start:

      beqz a0, LB_delayloop_end;
      addi a0, a0, -1;
      j LB_delayloop_start;
  
    .p2align 2
    LB_delayloop_end: 

    /* set 0 */
    li a0, 0;
    call FN_gpio_write_value;

    /* delay 2 */
    li a0, 0xffffff; 

    .p2align 2
    LB_delayloop2_start:

      beqz a0, LB_delayloop2_end;
      addi a0, a0, -1;
      j LB_delayloop2_start;
  
    .p2align 2
    LB_delayloop2_end: 

  j control_gpio21;

ret;
.p2align 2
FN_app_entry_end:
