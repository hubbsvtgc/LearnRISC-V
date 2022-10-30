
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

 .ifndef _HIFIVE1_REVB_SRC_INC_SPI_INC_
.equiv _HIFIVE1_REVB_SRC_INC_SPI_INC_, 1

.include "inc/mmap.inc"  /* FE310 Mmap */

.equiv SPI_SCKDIV_OFF, 0x00
.equiv SPI_SCKMODE_OFF, 0x04

.equiv SPI_CSID_OFF, 0x10     /* Chip Select ID */
.equiv SPI_CSDEF_OFF, 0x14    /* Chip Select default */
.equiv SPI_CSMODE_OFF, 0x18   /* Chip Select Mode */

.equiv SPI_DELAY0_OFF, 0x28
.equiv SPI_DELAY1_OFF, 0x2C

.equiv SPI_FMT_OFF, 0x40      /* Frame Format */

.equiv SPI_TXDATA_OFF, 0x48  /* Tx FIFO Data */
.equiv SPI_RXDATA_OFF, 0x4C  /* Rx FIFO Data */

.equiv SPI_TXMARK_OFF, 0x50  /* Tx watermark */
.equiv SPI_RXMARK_OFF, 0x54  /* Rx watermark */

.equiv SPI_IE_OFF, 0x70  /* Interrupt Enable  */
.equiv SPI_IP_OFF, 0x74  /* Interrupt Pending */

.endif
