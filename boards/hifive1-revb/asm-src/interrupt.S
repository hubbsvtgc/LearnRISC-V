
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/
.section .text

.equiv CSR_MIE_MEIE, 0x800 /* Bit 11 */
.equiv CSR_MSTATUS_MIE, 0x8 /* Bit 3 */

.global FN_intr_enable_mexternal;

/* Funtion to enable machine interrupt and
 * machine external interrupt */

 FN_intr_enable_mexternal:

   /* Read MIE csr and set bit 11 to enable external
    * interrupt */

    csrr t0, mie;

    li t1, CSR_MIE_MEIE;
    or t0, t0, t1;

    csrw mie, t0;

    /* Read MSTATUS csr and set bit 3
    to enable machine interrupt */

    csrr t0, mstatus;

    li t1, CSR_MSTATUS_MIE;
    or t0, t0, t1;

    csrw mstatus, t0;

 ret;

