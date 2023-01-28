
/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";
.include "inc/uart.inc";
.include "inc/mmap.inc";
.include "inc/gpio.inc"; /* .equiv GPIO18, 18   --UART1 Tx */

.global uart_tx_init;
.global uart_tx_loop_start;

Lalign4 uart_tx_init:

  addi sp, sp, -4;
  sw ra, 0(sp);

    /* Configure GPIO18 as UART1 TX */

    li a0, GPIO18;
    call gpio_set_as_iof;

    li a0, GPIO18; /* Pin number */
    li a1, 0; /* Select 0 - UART 1 -tx */
    call gpio_select_iof;

    /* set UART 1 to baud 115200
    With tlclk at 16Mhz, to achieve 115200 baud,
    divisor should be 138 */

    li t0, UART1_BASE;
    li t1, 138;
    sw t1, UART_BAUD_DIV_OFFSET(t0);

    /* set 2 stop bits */
    li a0, 1;
    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    slli a0, a0, 1;  /* shift input to stop bit position */
    or t1, t1, a0;   /* set stop bit count */
    sw t1, UART_TXCTRL_OFFSET(t0); /* Store back */

    /* Set tx wmark to 6 */
    li a0, 6;
    li t0, UART1_BASE;
    lhu t1, UART_TXCTRL_OFFSET+2(t0); /* Read present value */
    andi t1, t1, -8;
    or t1, t1, a0;
    sh t1, UART_TXCTRL_OFFSET+2(t0); /* Set wmark */

    /* send byte 0xc0 */
    li a0, 0xc0;
    li t0, UART1_BASE;
    sw a0, UART_TXDATA_OFFSET(t0);

    /* Enable UART 1 Tx
      bit[0]: 0 - disable, 1 - enable */

    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */
    ori t1, t1, 1;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Enable */

    lw ra, 0(sp);
    addi sp, sp, 4;

Lalign4 uart_tx_init_end:
ret;

nop;
Lalign4 uart_tx_loop_start:

  nop;
  li t0, UART1_BASE;

  wait_full:
  lw t1, UART_TXDATA_OFFSET(t0);
  slli t1, t1, 31 # TXDATA_FIFO_FULL;
  bnez t1, wait_full;

  li a0, 0x41; /* A */
  
  sb a0, UART_TXDATA_OFFSET(t0);

j uart_tx_loop_start;

nop;
Lalign4 uart_tx_loop_end:
