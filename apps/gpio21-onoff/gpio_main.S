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


 FN_app_entry:
/* Enable external interrupt */
call FN_intr_enable_mexternal; 

/* Set priority 3 to gpio interrupt source 29 */
li a0, GPIO21_INTERRUPT_SRC;
li a1, 3;
call FN_plic_set_priority;

li a1, 2;
call FN_plic_set_threshold;

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

control_gpio21:

/* set 1 */
li a0, GPIO21_BIT_POSITION;
call FN_gpio_write_value;

/* set 0 */
li a0, 0;
call FN_gpio_write_value;

j control_gpio21;



