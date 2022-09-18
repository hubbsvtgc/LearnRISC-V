
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

/* In FE310 G002, GPIO is a peripheral device mapped into internal memory map. 
 Each memory mapped register is 32 bits wide, each bit corresponding to each 
 gpio pin (0 to 31 pins) */


 /* --------------------------------------------
   OFFSETs for memory mapped registers for GPIO 
----------------------------------------------- */

.ifndef _HIFIVE1_REVB_SRC_INC_GPIO_INC_
.equiv _HIFIVE1_REVB_SRC_INC_GPIO_INC_, 1

.include "inc/mmap.inc"  /** FE310 Mmap */

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

.endif
