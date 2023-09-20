
/****************************************************************************
 *
 *  Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *  Author: Vincent <bsvtgc@gmail.com>
 *
 *  Power-Managemment Unit(PMU)
 ****************************************************************************/

.ifndef _HIFIVE1_REVB_SRC_INC_RTC_INC_
.equiv _HIFIVE1_REVB_SRC_INC_RTC_INC_, 1

/* rtccfg (offset 0x040) - config */
.equiv RTC_CFG_OFST, 0x40

/* rtccounthi (offset 0x04C) - high bits counter */
.equiv RTC_COUNT_HI_OFST, 0x4C 

/* rtccountlo (offset 0x048) - low bits counter */
.equiv RTC_COUNT_LO_OFST, 0x48

/* rtc compare register */
.equiv RTC_COMP_OFST, 0x60 

.equiv LF_EXTCLK_SEL_OFST, 0x7C
.equiv LF_OSCCFG_OFST, 0x70

.endif