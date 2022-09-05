/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.ifndef _HIFIVE1_REVB_SRC_INC_MACROS_INC_
.equiv _HIFIVE1_REVB_SRC_INC_MACROS_INC_, 1

/* Label align 4 bytes */
.macro Lalign4 label1:req
    .p2align 2;
    \label1\()
.endm

/* Label align 64 bytes */
.macro Lalign64 label2:req
    .p2align 6;
    \label2\()
.endm

.endif
