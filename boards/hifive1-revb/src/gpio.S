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
.global FN_gpio_configure_as_input;
.global FN_gpio_configure_as_output;
.global FN_gpio_configure_as_iof;
.global FN_gpio_write_value;
.global FN_gpio_enable_rise_intr;
.global FN_gpio_enable_high_intr;
.global FN_gpio_enable_high_intr;
.global FN_gpio_enable_high_intr;
.global FN_gpio_clear_rise_pend;
.global FN_gpio_select_iof;
.global FN_gpio_enable_internal_pullup;
.global FN_gpio_disable_internal_pullup;
.global gpio_set_high;
.global gpio_set_low;

/* --------------------------------------------
   Utility functions to configure and use GPIOs.
   All functions expect the argument in A0 register. 
----------------------------------------------- */

/* Configure gpio as input pin */
Lalign4 FN_gpio_configure_as_input:
    /* Register A0 has the pins to be configured as input */
    li t0, GPIO_BASE;
    lw t1, GPIO_IN_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_IN_EN_OFF(t0);
ret;

/* Configure gpio as output pin */
Lalign4 FN_gpio_configure_as_output:
    /* Register A0 has the pins to be configured as output */
    li t0, GPIO_BASE ;
    lw t1, GPIO_OUT_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_OUT_EN_OFF(t0);
ret;

/* Configure gpio pins as io functionality */
Lalign4 FN_gpio_configure_as_iof:
    /* Register A0 has the pins to be configured as io functionality */
    li t0, GPIO_BASE ;
    lw t1, GPIO_IOF_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_IOF_EN_OFF(t0);
ret;

/* Select gpio IoF */
Lalign4 FN_gpio_select_iof:
    /* Register A0 has the pins to select as io functionality */
    li t0, GPIO_BASE ;
    lw t1, GPIO_IOF_SEL_OFF(t0);
    not a0, a0;
    and t1, t1, a0;
    sw t1, GPIO_IOF_SEL_OFF(t0);
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

/* convert 0-31 to register bit position */
Lalign4 gpio_decimal2regbitpos:

    /* Register A0 has the gpio pin number in decimal (0-31) */

    beq a0, zero, gpio_decimal0;

    /* 1 << decimal value */

    li t0, 1;
    sll a0, t0, a0;
    ret;

Lalign4 gpio_decimal0:
    li a0, 1;
    ret;

/* Set a pin (0-31) high */

Lalign4 gpio_set_high:

    sw ra, 0(sp);
    /* dont save  sw a0, 4(sp); */

    call gpio_decimal2regbitpos;

   /*  lw a0, 4(sp); */
    lw ra, 0(sp);

    li t0, GPIO_BASE;
    lw t1, GPIO_OUT_VALUE_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_OUT_VALUE_OFF(t0);

ret;

/* Set a pin (0-31) low */

Lalign4 gpio_set_low:

    sw ra, 0(sp);

    call gpio_decimal2regbitpos;

    li t0, GPIO_BASE;
    lw t1, GPIO_OUT_VALUE_OFF(t0);
    xor t1, t1, a0; /* logic wont work if initial state is 0 */
    sw t1, GPIO_OUT_VALUE_OFF(t0);

    lw ra, 0(sp);

ret;
