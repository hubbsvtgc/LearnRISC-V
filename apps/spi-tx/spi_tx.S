
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";
.include "inc/gpio.inc";

.globl app_entry;

.equiv NOT_TEST, 1

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

    li a0, GPIO_AS_SPI_PINS;
    call FN_gpio_configure_as_iof;

    li a0, GPIO_AS_SPI_PINS;
    call FN_gpio_select_iof;

    /* set gpio0 high initially and then
    make it low for >3ns to reset D_RESET of Display */

    li a0, 1;
    call FN_gpio_configure_as_output;

    li a0, GPIO0;
    call gpio_set_high;

.ifdef NOT_TEST
    li a0, 0xff;
    call delay;
.endif
    li a0, GPIO0;
    call gpio_set_low;

.ifdef NOT_TEST
    li a0, 0xffff;
    call delay;
.endif

    li a0, GPIO0;
    call gpio_set_high;

    /* set gpio1 low for DorC# line to send commands to Display */

    li a0, 2;
    call FN_gpio_configure_as_output;

    li a0, GPIO1;
    call gpio_set_high; /* set DC high and then low TBD due to logic error */

.ifdef NOT_TEST
    li a0, 0xff;
    call delay;
.endif

    li a0, GPIO1;
    call gpio_set_low;

.ifdef NOT_TEST
    li a0, 0xff;
    call delay;
.endif

    /* send power on seq to ssd7317 */

    li a0, 0xFD; /* access */
    call spi_transmit;

    li a0, 0x12; /* unlock */
    call spi_transmit;

    li a0, 0xAE; /* display off - sleep mode */
    call spi_transmit;

    li a0, 0xD5; /* Clock divider or osc freq */
    call spi_transmit;
    li a0, 0x91;
    call spi_transmit;

    li a0, 0x20; /* Memory Addressing mode */
    call spi_transmit;
    li a0, 0x01; /* Page addressing mode, col auto +1 */
    call spi_transmit;

    li a0, 0xDA; /* COM Pins HW configuration */
    call spi_transmit;
    li a0, 0x12;
    call spi_transmit;

    li a0, 0x81; /* Contrast Control */
    call spi_transmit;

    li a0, 0x2A;  /* range 01 - ffh */
    call spi_transmit;

/* delay to avoid spi fifo overflow */

.ifdef NOT_TEST
    li a0, 0xfffff;
    call delay;
.endif

    li a0, 0xAD; /* IREF */
    call spi_transmit;

    li a0, 0x10; /* Disable Internal iref */
    call spi_transmit;

    li a0, 0xA1; /* Set segment re-map */
    call spi_transmit;

    li a0, 0xC8; /* Set Com output scan dir */
    call spi_transmit;

    li a0, 0xA2; /* Display Start line */
    call spi_transmit;
    li a0, 0;
    call spi_transmit;

    li a0, 0xD3; /* Display offset */
    call spi_transmit;
    li a0, 0; 
    call spi_transmit;



/* delay to avoid spi fifo overflow */

.ifdef NOT_TEST
    li a0, 0xfffff;
    call delay;
.endif

/* Discharge , pre-charge period  
   Need to set a proper value: THis value DONT work 
    li a0, 0xD9; 
    call spi_transmit;
    li a0, 0x43;
    call spi_transmit;
*/

    li a0, 0xA5; /* A4 - Display GDDRAM Contents, A5 - Entire display ON */
    call spi_transmit;

    li a0, 0xA6; /* A6: 0 - OFF, 1 - ON; A7: 0 - ON, 1 - OFF */
    call spi_transmit;

    li a0, 0xDB; /* VCOM deselect level */
    call spi_transmit;
    li a0, 0x30;
    call spi_transmit;

    li a0, 0xAF;
    call spi_transmit;

.ifdef NOT_TEST
    li a0, 0x2fffff;
    call delay;
.endif

/*
    li a0, 0xAe;
    call spi_transmit;
*/

    /* set GPIO1_OLED_DC low to send data to Display */

    li a0, GPIO1;
    call gpio_set_high;

    nop;

    j . 


ret;
Lalign4 _app_entry_end:
