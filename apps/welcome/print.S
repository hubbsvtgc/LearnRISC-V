
/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

# Welcome to LearnRISCV;
          # W e   l   c  o   m   e    t   o    L  e   a  r   n    R  I  S  C  V    LF CR  NULL
msg: .word 87,101,108,99,111,109,101, 116,111, 76,101,97,114,110, 82,73,83,67,86,  10,13, 00;

.include "inc/macros.inc";
.include "inc/uart.inc";
.include "inc/mmap.inc";
.include "inc/gpio.inc"; /* .equiv GPIO17, 17   --UART0 Tx */

.global uart_tx_init;
.global uart_tx_loop_start;

Lalign4 uart_tx_init:

  addi sp, sp, -4;
  sw ra, 0(sp);

    /* Configure GPIO17 as UART0 TX */

    li a0, GPIO17;
    call gpio_set_as_iof;

    li a0, GPIO17; /* Pin number */
    li a1, 0; /* Select 0 - UART 1 -tx */
    call gpio_select_iof;

    /* set UART 1 to baud 115200
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

    /* Set tx wmark to 7 */
    li a0, 7;
    li t0, UART0_BASE;
    lhu t1, UART_TXCTRL_OFFSET+2(t0); /* Read present value */
    andi t1, t1, -8;
    or t1, t1, a0;
    sh t1, UART_TXCTRL_OFFSET+2(t0); /* Set wmark */

    /* send byte 0xc0 */
    li a0, 0xc0;
    li t0, UART0_BASE;
    sw a0, UART_TXDATA_OFFSET(t0);

    /* Enable UART 1 Tx
      bit[0]: 0 - disable, 1 - enable */

    li t0, UART0_BASE;
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
  li t0, UART0_BASE;

  la t2, msg # msg start addr in t2;
  addi t3, t2, 84 # msg end addr in t3;
  add t4, t2, zero;

  wait_full:
  lw t1, UART_TXDATA_OFFSET(t0);
  srli t1, t1, 31 # TXDATA_FIFO_FULL;
  bnez t1, wait_full;

  lw a0, 0(t4);
  sb a0, UART_TXDATA_OFFSET(t0);

  addi t4, t4, 4;
  bleu t4, t3, all_good;
  addi t4, t2, 0;
  nop;
all_good:
  nop;
j wait_full;

nop;
Lalign4 uart_tx_loop_end:
