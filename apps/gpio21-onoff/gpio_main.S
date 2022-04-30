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

.equiv GPIO21_INTRSRC_ID, 29 /* Bit pos 28 */

 /* Configure GPIOs
 * 31                 16 
 * 0000 0000 0010 0000
 * 15                 0
 * 0000 0000 0000 0000 as output */
.equiv GPIO21_BPOS, 0x00200000

 FN_app_entry:

/* Enable machine external interrupt */
call FN_intr_enable_mexternal; 

/* Enable PLIC for interrupt 
 * source id 27 - GPIO 19 
 * source id 29 - GPIO 21
 * source id 30 - GPIO 30
 */

li a0, GPIO21_INTRSRC_ID;
call FN_plic_enable_src_id;

li a0, GPIO21_BPOS; 
call FN_gpio_configure_as_output;

control_gpio21:

/* set 1 */
li a0, GPIO21_BPOS;
call FN_gpio_write_value;

/* set 0 */
li a0, 0;
call FN_gpio_write_value;

j control_gpio21;



