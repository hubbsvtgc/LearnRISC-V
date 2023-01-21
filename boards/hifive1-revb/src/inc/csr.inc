
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.ifndef _HIFIVE1_REVB_SRC_INC_CSR_INC_

.equiv _HIFIVE1_REVB_SRC_INC_CSR_INC_, 1

/* Machine Trap Setup Related CSR_BITPOS */
/* mstatus, mtvec, mie are 3 major to set up
   mstatus - global setup */

.equiv MSTATUS_MIE, 0x8 /* Bit 3 - Machine Interrupt Enable */
.equiv MIE_MTIE, 0x80 /* Bit 7 - Machint Timer Interrupt */
.equiv MIE_MEIE, 0x800 /* Bit 11 - Machine External Interrupt */

/* Machine Trap Handler Related */

.equiv MIP_MTIE, 0x80 /* Bit 7 - Machint Timer Interrupt */
.equiv MIP_MEIE, 0x800 /* Bit 11 - Machine External Interrupt */

.endif
