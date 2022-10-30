
/****************************************************************************
 *
 *  Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *  Author: Vincent <bsvtgc@gmail.com>
 *
 *  Power-Managemment Unit(PMU)
 ****************************************************************************/
.ifndef _HIFIVE1_REVB_SRC_INC_PMU_INC_
.equiv _HIFIVE1_REVB_SRC_INC_PMU_INC_, 1

.equiv PMU_WAKE_I0_OFST, 0x100
.equiv PMU_WAKE_I1_OFST, 0x104
.equiv PMU_WAKE_I2_OFST, 0x108
.equiv PMU_WAKE_I3_OFST, 0x10C
.equiv PMU_WAKE_I4_OFST, 0x110
.equiv PMU_WAKE_I5_OFST, 0x114
.equiv PMU_WAKE_I6_OFST, 0x118
.equiv PMU_WAKE_I7_OFST, 0x11C

.equiv PMU_SLEEP_I0_OFST, 0x120
.equiv PMU_SLEEP_I1_OFST, 0x124
.equiv PMU_SLEEP_I2_OFST, 0x128
.equiv PMU_SLEEP_I3_OFST, 0x12C
.equiv PMU_SLEEP_I4_OFST, 0x130
.equiv PMU_SLEEP_I5_OFST, 0x134
.equiv PMU_SLEEP_I6_OFST, 0x138
.equiv PMU_SLEEP_I7_OFST, 0x13C

.equiv PMU_IE_OFST, 0x140
.equiv PMU_CAUSE_OFST, 0x144
.equiv PMU_SLEEP_OFST, 0x148
.equiv PMU_KEY_OFST, 0x14C

.equiv PMU_KEY, 0x51F15E

.endif
