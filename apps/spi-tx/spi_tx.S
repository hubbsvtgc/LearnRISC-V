
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";

.globl app_entry;

/* GPIO 0, 1, 2, 3, 4 & 5 used as below
   gpio0 -> gpio0     -> D_RESET_3ns
   gpio1 -> gpio1     -> oled_DorC#
   gpio2 -> spi1_cs0  -> D_CS
   gpio3 -> spi1_mosi -> D_SDI
   gpio4 -> spi1_miso -> NOT needed now
   gpio5 -> spi1_sck  -> D_SCL  */

.equiv GPIO_AS_SPI_PINS, 0x3C /* 0011 1100 */

.section .data

/* Unlock command reg addr: 0xFD,  0x12 -> unlock, 0x16 -> lock */
/* Display command: 0xAE->off, 0xA4->Entire off, 0xA6->normal, 0xAH->on, */
/* Precharge Period reg: 0xD9, value?? 0x43, 0x22 */

/*                         --UNLOCK--  -OFF- --FREQ---   --Maddrmode --HWpin--    */
ssd7317_poweron_seq: .byte 0xFD, 0x12, 0xAE, 0xDF, 0x91, 0x20, 0x01, 0xDA, 0x12, 0x81, 0x2A;

Lalign4 delay: /* value passed in a0 */

Lalign4 delayloop_start:

    beqz a0, delayloop_end;
    addi a0, a0, -1;
    j delayloop_start;

Lalign4 delayloop_end:

ret;

Lalign4 app_entry:

    li a0, GPIO_AS_SPI_PINS;
    call FN_gpio_configure_as_iof;

    li a0, GPIO_AS_SPI_PINS;
    call FN_gpio_select_iof;

    /* set gpio0 with pull up, high initially and then
    make it low for >3ns to reset D_RESET of Display */

    li a0, 1;
    call FN_gpio_write_value;

    li a0, 1;
    call FN_gpio_configure_as_output;

    li a0, 0xff;
    call delay;

    li a0, 0;
    call FN_gpio_write_value;

    li a0, 0xffff;
    call delay;

    li a0, 1;
    call FN_gpio_write_value;

Lalign4 loop_forever:

    li a0, 0xcc;
    call spi_transmit;

    li a0, 0xfffff;
    call delay;

j loop_forever;

    j .

ret;
Lalign4 _app_entry_end:
