
/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

 .section .text

.include "inc/mmap.inc" /* To include SPI base address */
.include "inc/macros.inc"
.include "inc/spi.inc"

/* Make functions visible to app */
.global spi_receive;
.global spi_transmit;

/* --------------------------------------------
   Utility functions to configure and use GPIOs.
   All functions expect the argument in A0 register. 
----------------------------------------------- */

/*  Read byte from spi rx fifo into a0 reg */

Lalign4 spi_receive:

    li t0, SPI1_BASE;
    lw a0, SPI_RXDATA_OFF(t0);

ret;

/*  Write byte from a0 to spi tx fifo */

Lalign4 spi_transmit:

    li t0, SPI1_BASE;
    sw a0, SPI_TXDATA_OFF(t0);

ret;

/* NO change in Chip Select ID, default is 0 to use CS0 */

/* NO change in Chip Select default register keep CS0 as high in inactive */

/* NO change in Chip select mode as defaut 0 is AUTO which is 
   assert/desert CS at the beginning/end of each frame */

/* NO Change in delay as default delay0 & delay1 is 1 SCK */

/* NO Change in frame fmt register as default 
   spi protocol, spi endianess, spi io direction =x, and num bits/frame = 8 */