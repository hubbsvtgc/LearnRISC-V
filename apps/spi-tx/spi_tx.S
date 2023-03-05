
/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";
.include "inc/gpio.inc";

.globl app_entry;

.equiv RUN, 1

/* GPIO 0, 1, 2, 3, 4 & 5 used as below
   gpio0 -> gpio0     -> D_RESET_3ns
   gpio1 -> gpio1     -> oled_DorC#
   gpio2 -> spi1_cs0  -> D_CS
   gpio3 -> spi1_mosi -> D_SDI
   gpio4 -> spi1_miso -> NOT needed now
   gpio5 -> spi1_sck  -> D_SCL  */

.equiv GPIO_AS_SPI_PINS, 0x3C /* 0011 1100 */

.section .text

Lalign4 delay: /* value passed in a0 */

Lalign4 delayloop_start:

    beqz a0, delayloop_end;
    addi a0, a0, -1;
    j delayloop_start;

Lalign4 delayloop_end:
ret;

Lalign4 app_entry:

    li a0, GPIO0;
    call gpio_set_as_gpio;

    li a0, GPIO1;
    call gpio_set_as_gpio;

    li a0, GPIO2;
    call gpio_set_as_iof;

    li a0, GPIO2;
    li a1, 0;
    call gpio_select_iof;

    li a0, GPIO3;
    call gpio_set_as_iof;

    li a0, GPIO3;
    li a1, 0;
    call gpio_select_iof;

    li a0, GPIO4;
    call gpio_set_as_iof;

    li a0, GPIO4;
    li a1, 0;
    call gpio_select_iof;

    li a0, GPIO5;
    call gpio_set_as_iof;

    li a0, GPIO5;
    li a1, 0;
    call gpio_select_iof;

    /* set gpio0 high initially and then
    make it low for >3ns to reset D_RESET of Display */

    li a0, 1;
    call gpio_set_as_output;

    li a0, GPIO0;
    call gpio_set_high;

.ifdef RUN
    li a0, 0xff;
    call delay;
.endif

    li a0, GPIO0;
    call gpio_set_low;

.ifdef RUN
    li a0, 0xffff;
    call delay;
.endif

    li a0, GPIO0;
    call gpio_set_high;

.ifdef RUN
    li a0, 0xff;
    call delay;
.endif

   /* set gpio1 low for DorC# line to send commands to Display */

    li a0, 2;
    call gpio_set_as_output;

    li a0, GPIO1;
    call gpio_set_low;

.ifdef RUN
    li a0, 0xff;
    call delay;
.endif

    /* send power on seq to ssd7317 */

    li a0, 0xFD; /* access */
    call spi_transmit;

    li a0, 0x12; /* unlock */
    call spi_transmit;

oled_on_off_loop:

    li a0, 0xAE; /* display off - sleep mode */
    call spi_transmit;

.ifdef RUN
    li a0, 0xfffff;
    call delay;
.endif

    li a0, 0xAF; /* display on */
    call spi_transmit;

.ifdef RUN
    li a0, 0xfffff;
    call delay;
.endif

j oled_on_off_loop;

    nop;

    j . 


ret;
Lalign4 _app_entry_end:
