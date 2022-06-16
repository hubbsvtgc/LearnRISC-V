/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

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

 /* In FE310 G002, GPIO is a peripheral device mapped into internal memory map. 
 Each memory mapped register is 32 bits wide, each bit corresponding to each 
 gpio pin (0 to 31 pins) */

/* --------------------------------------------
   OFFSETs for memory mapped registers for GPIO 
----------------------------------------------- */
.equiv GPIO_BASE, 0x10012000  /* GPIO Base address */
.equiv GPIO_IN_VALUE_OFF, 0x00
.equiv GPIO_IN_EN_OFF, 0x04
.equiv GPIO_OUT_EN_OFF, 0x08
.equiv GPIO_OUT_VALUE_OFF, 0x0C
.equiv GPIO_INTERNAL_PULL_EN_OFF, 0x10
.equiv GPIO_DS_OFF, 0x14
.equiv GPIO_RISE_INTR_EN_OFF, 0x18
.equiv GPIO_RISE_INTR_PEND_OFF, 0x1C
.equiv GPIO_FALL_INTR_EN_OFF, 0x20
.equiv GPIO_FALL_INTR_PEND_OFF, 0x24
.equiv GPIO_HI_INTR_EN_OFF, 0x28
.equiv GPIO_HI_INTR_PEND_OFF, 0x2C
.equiv GPIO_LOW_INTR_EN_OFF, 0x30
.equiv GPIO_LOW_INTR_PEND_OFF, 0x34
.equiv GPIO_IOF_EN_OFF, 0x38
.equiv GPIO_IOF_SEL_OFF, 0x3C
.equiv GPIO_OUT_XOR_OFF, 0x40

.p2align 2

/* --------------------------------------------
   Utility functions to configure and use GPIOs.
   All functions expect the argument in A0 register. 
----------------------------------------------- */

/* Configure gpio as input pin */
.p2align 2
FN_gpio_configure_as_input:
    /* Register A0 has the pins to be configured as input */
    li t0, GPIO_BASE;
    lw t1, GPIO_IN_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_IN_EN_OFF(t0);
ret;

/* Configure gpio as output pin */
.p2align 2
FN_gpio_configure_as_output:
    /* Register A0 has the pins to be configured as output */
    li t0, GPIO_BASE ;
    lw t1, GPIO_OUT_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_OUT_EN_OFF(t0);
ret;

/* Configure gpio pins as io functionality */
.p2align 2
FN_gpio_configure_as_iof:
    /* Register A0 has the pins to be configured as io functionality */
    li t0, GPIO_BASE ;
    lw t1, GPIO_IOF_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_IOF_EN_OFF(t0);
ret;

/* Select gpio IoF */
.p2align 2
FN_gpio_select_iof:
    /* Register A0 has the pins to select as io functionality */
    li t0, GPIO_BASE ;
    lw t1, GPIO_IOF_SEL_OFF(t0);
    not a0, a0;
    and t1, t1, a0;
    sw t1, GPIO_IOF_SEL_OFF(t0);
ret;

/* Write value to gpio pins - 0 bit value to gpio 0, Correspondingly 
   Ensure write is performed on pins configured as OUT */
.p2align 2
FN_gpio_write_value:
    /* Register A0 has the values for all gpios to output 
     * THis dont need a read, or & write, 
     * instead just a write */
    li t0, GPIO_BASE ;
    sw a0, GPIO_OUT_VALUE_OFF(t0);
ret;

/* Read value from gpio pins - 0 bit value to gpio 0, Correspondingly 
   Ensure read is performed on pins configured as IN */
.p2align 2
FN_gpio_read_value:

    li t0, GPIO_BASE ;
    lw a0, GPIO_IN_VALUE_OFF(t0);
    /* Register A0 has the read values of all gpio pins */

ret;

/* Enable rise interrupt for gpios */
.p2align 2
FN_gpio_enable_rise_intr:
    li t0, GPIO_BASE;
    lw t1, GPIO_RISE_INTR_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_RISE_INTR_EN_OFF(t0);
ret;

/* Enable high interrupt for gpios */
.p2align 2
FN_gpio_enable_high_intr:
    li t0, GPIO_BASE ;
    lw t1, GPIO_HI_INTR_EN_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_HI_INTR_EN_OFF(t0);
ret;

/* Clear rise pending  bit for gpios */
.p2align 2
FN_gpio_clear_rise_pend:
    li t0, GPIO_BASE;
    lw t1, GPIO_RISE_INTR_PEND_OFF(t0);
    or t1, t1, a0;
    sw t1, GPIO_RISE_INTR_PEND_OFF(t0);
ret;
