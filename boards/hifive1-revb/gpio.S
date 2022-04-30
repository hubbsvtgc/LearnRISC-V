/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/


 /* In FE310 G002, GPIO is a peripheral device mapped into internal memory map. 
 Each memory mapped register is 32 bits wide, each bit corresponding to each 
 gpio pin (0 to 31 pins) */

/* GPIO Base address */
 .equiv GPIO_BASE, 0x10012000

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

/* IO Function select */
 .equiv GPIO_IOF_SEL_OFF, 0x3C

 /* Output XOR (invert) */
 .equiv GPIO_OUT_XOR_OFF, 0x40

