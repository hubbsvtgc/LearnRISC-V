
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
.include "inc/gpio.inc"; /* .equiv GPIO17, 18   --UART0 Tx */

.global uart_rec_and_tx_loop;
.globl app_entry;

Lalign4 app_entry:

    /* Configure GPIO17 as UART0 TX */

    li a0, GPIO17;
    call gpio_set_as_iof;

    li a0, GPIO17; /* Pin number */
    li a1, 0; /* Select 0 - UART 0 -tx */
    call gpio_select_iof;

     /* Configure GPIO16 as UART0 RX */

    li a0, GPIO16;
    call gpio_set_as_iof;

    li a0, GPIO16; /* Pin number */
    li a1, 0; /* Select 0 - UART 0 -rx */
    call gpio_select_iof;

    /* set UART 0 to baud 115200
    With tlclk at 16Mhz, to achieve 115200 baud,
    divisor should be 138 */

    li t0, UART0_BASE;
    li t1, 138;
    sw t1, UART_BAUD_DIV_OFFSET(t0);

    /* set 2 stop bits */
    li a0, 1;
    li t0, UART0_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    slli a0, a0, 1;  /* shift input to stop bit position */
    or t1, t1, a0;   /* set stop bit count */
    sw t1, UART_TXCTRL_OFFSET(t0); /* Store back */

    /* Set tx wmark to 6 */
    li a0, 6;
    li t0, UART0_BASE;
    lhu t1, UART_TXCTRL_OFFSET+2(t0); /* Read present value */
    andi t1, t1, -8;
    or t1, t1, a0;
    sh t1, UART_TXCTRL_OFFSET+2(t0); /* Set wmark */

    /* send byte 0xc0 */
    li a0, 0xc0;
    li t0, UART0_BASE;
    sw a0, UART_TXDATA_OFFSET(t0);

    /* Enable UART0 Tx
      bit[0]: 0 - disable, 1 - enable */

    li t0, UART0_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */
    ori t1, t1, 1;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Enable */

   


Lalign4 uart_rec_and_tx_loop:

  nop;
  li t0, UART0_BASE;

   /* Enable UART0 Rx
      bit[0]: 0 - disable, 1 - enable */
    lw t1, UART_RXCTRL_OFFSET(t0); /* Read present value */
    ori t1, t1, 1;
    sw t1, UART_RXCTRL_OFFSET(t0); /* Enable */

    /* Enable UART0 Tx
      bit[0]: 0 - disable, 1 - enable */
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */
    ori t1, t1, 1;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Enable */

wait_for_data_in_rx:
  lw t1, UART_RXDATA_OFFSET(t0);
  slli t1, t1, 31 # Check if rx fifo is not empty ;
  bnez t1, wait_for_data_in_rx;
  lb a0, UART_RXDATA_OFFSET(t0);

wait_for_fifo_space_in_tx:
  lw t1, UART_TXDATA_OFFSET(t0);
  slli t1, t1, 31 # Check if tx fifo is not full ;
  bnez t1, wait_for_fifo_space_in_tx;

  # li a0, 0x41;  
  
  sb a0, UART_TXDATA_OFFSET(t0); #Write back the read data


   /* Disable UART0 Rx
      bit[0]: 0 - disable, 1 - enable */
    lw t1, UART_RXCTRL_OFFSET(t0); /* Read present value */
    li t2, 1;
    not t2, t2;
    and t1, t1, t2;
    sw t1, UART_RXCTRL_OFFSET(t0); /* disable */

    /* Disable UART0 tx
      bit[0]: 0 - disable, 1 - enable */
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */
    li t2, 1;
    not t2, t2;
    and t1, t1, t2;
    sw t1, UART_TXCTRL_OFFSET(t0); /* disable */

j uart_rec_and_tx_loop;

nop;
Lalign4 uart_tx_loop_end:
nop;
