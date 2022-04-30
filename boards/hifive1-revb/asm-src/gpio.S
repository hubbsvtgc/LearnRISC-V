/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

/* Read value from gpio pins - 0 bit value to gpio 0, Correspondingly 
   Ensure read is performed on pins configured as IN */
.global FN_gpio_read_value;

/* Configure gpio as input pin */
.global FN_gpio_configure_as_input;

/* Configure gpio as output pin */
.global FN_gpio_configure_as_output;

/* Configure gpio pins as io functionality */
.global FN_gpio_configure_as_iof;

/* Write value to gpio pins - 0 bit value to gpio 0, Correspondingly 
   Ensure write is performed on pins configured as OUT */
.global FN_gpio_write_value;

/* Enable rise interrupt for gpios */
.global FN_gpio_enable_rise_intr;

 /* Enable high interrupt for gpios */

.global FN_gpio_enable_high_intr;

 /* Enable high interrupt for gpios */
.global FN_gpio_enable_high_intr;

 /* Enable high interrupt for gpios */
.global FN_gpio_enable_high_intr;


 /* In FE310 G002, GPIO is a peripheral device mapped into internal memory map. 
 Each memory mapped register is 32 bits wide, each bit corresponding to each 
 gpio pin (0 to 31 pins) */

/* GPIO Base address */
 .equiv GPIO_BASE, 0x10012000

/* --------------------------------------------
   OFFSETs for memory mapped registers for GPIO 
----------------------------------------------- */

/* Input value on pin */
 .equiv GPIO_IN_VALUE_OFF, 0x00

/* Pin input enable */
 .equiv GPIO_IN_EN_OFF, 0x04

/* Pin output enable */
 .equiv GPIO_OUT_EN_OFF, 0x08

/* Pin output value */
.equiv GPIO_OUT_VALUE_OFF, 0x0C

/* Internal pull up enable */
.equiv GPIO_INTERNAL_PULL_EN_OFF, 0x10

/* Pin drive strength */
.equiv GPIO_DS_OFF, 0x14

/* Rise interrupt enable */
 .equiv GPIO_RISE_INTR_EN_OFF, 0x18

/* Rise interrupt pending */
 .equiv GPIO_RISE_INTR_PEND_OFF, 0x1C

/* Fall interrupt enable */
 .equiv GPIO_FALL_INTR_EN_OFF, 0x20

/* Fall interrupt pending */
 .equiv GPIO_FALL_INTR_PEND_OFF, 0x24

/* High interrupt enable */
 .equiv GPIO_HI_INTR_EN_OFF, 0x28

/* High interrupt pending */
 .equiv GPIO_HI_INTR_PEND_OFF, 0x2C

 /* Low interrupt enable */
 .equiv GPIO_LOW_INTR_EN_OFF, 0x30

/* Low interrupt pending */
 .equiv GPIO_LOW_INTR_PEND_OFF, 0x34

/* IO Function Select, 
    if enabled, choose the IO functionality in iof_sel*/
 .equiv GPIO_IOF_EN_OFF, 0x38
 
 /* IO function select */

 .equiv GPIO_IOF_SEL_OFF, 0x3C

 /* Output XOR (invert) */
 .equiv GPIO_OUT_XOR_OFF, 0x40

/* --------------------------------------------
   Utility functions to configure and use GPIOs.
   All functions expect the argument in A0 register. 
----------------------------------------------- */

/* Configure gpio as input pin */
FN_gpio_configure_as_input:
    /* Register A0 has the pins to be configured as input */
    li t0, GPIO_BASE + GPIO_IN_EN_OFF;
    sw a0, 0(t0);
ret;

/* Configure gpio as output pin */
FN_gpio_configure_as_output:
    /* Register A0 has the pins to be configured as output */
    li t0, GPIO_BASE + GPIO_OUT_EN_OFF;
    lw t1, 0(t0);
    or t1, t1, a0;
    sw t1, 0(t0);
ret;

/* Configure gpio pins as io functionality */
FN_gpio_configure_as_iof:
    /* Register A0 has the pins to be configured as io functionality */
    li t0, GPIO_BASE + GPIO_IOF_EN_OFF;
    lw t1, 0(t0);
    or t1, t1, a0;
    sw t1, 0(t0);
ret;

/* Write value to gpio pins - 0 bit value to gpio 0, Correspondingly 
   Ensure write is performed on pins configured as OUT */
FN_gpio_write_value:
    /* Register A0 has the values for all gpios to output 
     * THis dont need a read, or & write, 
     * instead just a write */
    li t0, GPIO_BASE + GPIO_OUT_VALUE_OFF;
    sw a0, 0(t0);
ret;

/* Read value from gpio pins - 0 bit value to gpio 0, Correspondingly 
   Ensure read is performed on pins configured as IN */
FN_gpio_read_value:

    li t0, GPIO_BASE + GPIO_IN_VALUE_OFF;
    lw a0, 0(t0);
    /* Register A0 has the read values of all gpio pins */

ret;

/* Enable rise interrupt for gpios */
FN_gpio_enable_rise_intr:
    li t0, GPIO_BASE + GPIO_RISE_INTR_EN_OFF;
    lw t1, 0(t0);
    or t1, t1, a0;
    sw t1, 0(t0);
ret;


/* Enable high interrupt for gpios */
FN_gpio_enable_high_intr:
    li t0, GPIO_BASE + GPIO_HI_INTR_EN_OFF;
    lw t1, 0(t0);
    or t1, t1, a0;
    sw t1, 0(t0);
ret;

