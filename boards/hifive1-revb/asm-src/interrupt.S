
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/
.section .text

.equiv MIE_MEIE, 0x00000800 /* Bit 11 */

.global FN_intr_enable_mexternal;

 FN_intr_enable_mexternal:

   /* Read MIE and set bit 11 to enable external
    * interrupt */

    csrr t0, mie;
/*
    li t1, 1;
    slli t1, t1, 11; 
    or t0, t0, t1;
*/
    li t1, MIE_MEIE;
    or t0, t0, t1;
    
    csrw mie, t0;
 ret;

