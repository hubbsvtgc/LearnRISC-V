
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";

.globl app_entry;

 /* GPIO 2, 3, 4 & 5 used as below
    gpio2 - spi1_cs0
    gpio3 - spi1_mosi
    gpio4 - spi1_miso
    gpio5 - spi1_sck  */

.equiv GPIO_AS_SPI_PINS, 0x3C /* 0011 1100 */

Lalign4 app_entry:

    li a0, GPIO_AS_SPI_PINS;
    call FN_gpio_configure_as_iof;

    li a0, GPIO_AS_SPI_PINS;
    call FN_gpio_select_iof;

loop_forever:

    li a0, 0xcc;
    call spi_transmit;

    /* delay */
    li a0, 0xfffff;

    Lalign4 LB_delayloop_start:

        beqz a0, LB_delayloop_end;
        addi a0, a0, -1;
        j LB_delayloop_start;
  
    Lalign4 LB_delayloop_end:

j loop_forever;

    j .

ret;
Lalign4 _app_entry_end:
