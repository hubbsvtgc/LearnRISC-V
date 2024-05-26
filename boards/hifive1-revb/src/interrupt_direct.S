/****************************************************************************
 *
 *   Copyright (C) 2024 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.include "inc/config.inc"  /** Build Configuration */
/* .equiv INTERRUPT_STACK_DEPTH_IN_BYTES, 31 * 4 */
/* .ifdef INTERRUPT_DIRECT_MODE */

    /* mscratch registere is dedicated only for machine mode 
     * mscratch has the address of interrupt stack 
     * lets swap with sp register */
    csrw mscratch, sp

    addi sp, sp, -124 /* 31 registers each of a word */







/* .endif */
