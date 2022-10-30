/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/mmap.inc" /* To include GPIO base address */
.include "inc/macros.inc"
.include "inc/gpio.inc"

/* Make functions visible to app */
.global FN_gpio_read_value;
.global gpio_set_as_input;
.global gpio_set_as_output;
.global gpio_set_as_iof;
.global FN_gpio_write_value;
.global FN_gpio_enable_rise_intr;
.global FN_gpio_enable_high_intr;
.global FN_gpio_enable_high_intr;
.global FN_gpio_enable_high_intr;
.global FN_gpio_clear_rise_pend;
.global gpio_select_iof;
.global FN_gpio_enable_internal_pullup;
.global FN_gpio_disable_internal_pullup;
.global gpio_set_high;
.global gpio_set_low;
.global gpio_set_as_gpio;

/* --------------------------------------------
   Utility functions to configure and use GPIOs.
   All functions expect the argument in A0 register. 
----------------------------------------------- */

/* Generate mask with 1 */

/* reg a0 has the gpio number ( 0 - 31) */

Lalign4 gpio_generate_mask:

    beq a0, zero, retone;
    li t0, 1;
    sll a0, t0, a0; /* 1 << gpio number */
    j  gpio_generate_mask_end;

retone:
    li a0, 1;

gpio_generate_mask_end:
    nop;
ret;

/* Configure gpio as input pin */

Lalign4 gpio_set_as_input:

      sw ra, 0(sp);

    /* Register A0 has the gpio pin number */
    /* Generate the mask */
    call gpio_generate_mask;

    lw ra, 0(sp);

    /* Perform bitwise OR operation */
    li t0, GPIO_BASE;
    lw t1, GPIO_IN_EN_OFF(t0);
    or a0, t1, a0;

    sw a0, GPIO_IN_EN_OFF(t0);

ret;

/* Configure gpio as output pin */

Lalign4 gpio_set_as_output:

    sw ra, 0(sp);

    /* Register A0 has the gpio pin number */
    /* Generate the mask */
    call gpio_generate_mask;

    lw ra, 0(sp);

    /* Perform bitwise OR operation */
    li t0, GPIO_BASE;
    lw t1, GPIO_OUT_EN_OFF(t0);
    or a0, t1, a0;

    sw a0, GPIO_OUT_EN_OFF(t0);

ret;

/* Configure pin as io */

Lalign4 gpio_set_as_iof:

    sw ra, 0(sp);

    /* Register A0 has the gpio pin number */
    /* Generate the mask */
    call gpio_generate_mask;

    lw ra, 0(sp);

    /* Perform bitwise OR operation */
    li t0, GPIO_BASE;
    lw t1, GPIO_IOF_EN_OFF(t0);
    or a0, t1, a0;

    sw a0, GPIO_IOF_EN_OFF(t0);

ret;

/* Select pin io functionality */
/* reg a0 has the pin number */
/* reg a1 has 0 or 1 */

Lalign4 gpio_select_iof:

    sw ra, 0(sp);

    /* Register A0 has the gpio pin number */
    /* Generate the mask */
    call gpio_generate_mask;

    lw ra, 0(sp);

    /* Read existing value */
    li t0, GPIO_BASE;
    lw t1, GPIO_IOF_SEL_OFF(t0);

beq a1, zero, iofzero;

    /* Perform bitwise OR operation */
    or a0, t1, a0;
    j gpio_select_iof_end;

iofzero:
    /* Invert the mask */
    not a0, a0;

    /* Perform bitwise AND operation */
    and a0, t1, a0;

gpio_select_iof_end:
    sw a0, GPIO_IOF_SEL_OFF(t0);
    nop;
ret;

/* Write value to gpio pins - 0 bit value to gpio 0, Correspondingly 
   Ensure write is performed on pins configured as OUT */
Lalign4 FN_gpio_write_value:
    /* Register A0 has the values for all gpios to output 
     * THis dont need a read, or & write, 
     * instead just a write */
    li t0, GPIO_BASE ;
    sw a0, GPIO_OUT_VALUE_OFF(t0);
ret;

/* Read value from gpio pins - 0 bit value to gpio 0, Correspondingly 
   Ensure read is performed on pins configured as IN */
Lalign4 FN_gpio_read_value:

    li t0, GPIO_BASE ;
    lw a0, GPIO_IN_VALUE_OFF(t0);
    /* Register A0 has the read values of all gpio pins */

ret;

/* Enable rise interrupt for gpios */

Lalign4 FN_gpio_enable_rise_intr:
    li t0, GPIO_BASE;
    lw t1, GPIO_RISE_INTR_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_RISE_INTR_EN_OFF(t0);
ret;

/* Enable high interrupt for gpios */
Lalign4 FN_gpio_enable_high_intr:
    li t0, GPIO_BASE ;
    lw t1, GPIO_HI_INTR_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_HI_INTR_EN_OFF(t0);
ret;

/* Clear rise pending  bit for gpios */
Lalign4 FN_gpio_clear_rise_pend:
    li t0, GPIO_BASE;
    lw t1, GPIO_RISE_INTR_PEND_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_RISE_INTR_PEND_OFF(t0);
ret;

/* Enable internal pullup for pins */
Lalign4 FN_gpio_enable_internal_pullup:
    /* Register A0 has the pins to enable internal pull up */
    li t0, GPIO_BASE ;
    lw t1, GPIO_INTERNAL_PULL_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_IOF_EN_OFF(t0);
ret;

/* Disable internal pullup for pins */
Lalign4 FN_gpio_disable_internal_pullup:
    /* Register A0 has the pins to enable internal pull up */
    li t0, GPIO_BASE ;
    lw t1, GPIO_INTERNAL_PULL_EN_OFF(t0);
    and t1, t1, a0;
    xori t1, t1, -1;
    sw t1, GPIO_IOF_EN_OFF(t0);
ret;

/* Configure as gpio */
Lalign4 gpio_set_as_gpio:

    sw ra, 0(sp);

    /* Register A0 has the gpio pin number */
    /* Generate the mask */
    call gpio_generate_mask;

    lw ra, 0(sp);

    /* Invert the mask */
    not a0, a0;

    /* Perform bitwise AND operation */
    li t0, GPIO_BASE;
    lw t1, GPIO_IOF_EN_OFF(t0);
    and a0, t1, a0;

    sw a0, GPIO_IOF_EN_OFF(t0);

ret;

Lalign4 gpio_set_high:

    sw ra, 0(sp);

    /* Register A0 has the gpio pin number */
    /* Generate the mask */
    call gpio_generate_mask;

    lw ra, 0(sp);

    /* Perform bitwise OR operation */
    li t0, GPIO_BASE;
    lw t1, GPIO_OUT_VALUE_OFF(t0);
    or a0, t1, a0;

    sw a0, GPIO_OUT_VALUE_OFF(t0);

ret;

Lalign4 gpio_set_low:

    sw ra, 0(sp);

    /* Register A0 has the gpio pin number */
    /* Generate the mask */
    call gpio_generate_mask;

    lw ra, 0(sp);

    /* Invert the mask */
    not a0, a0;

    /* Perform bitwise AND operation */
    li t0, GPIO_BASE;
    lw t1, GPIO_OUT_VALUE_OFF(t0);
    and a0, t1, a0;

    sw a0, GPIO_OUT_VALUE_OFF(t0);

ret;
