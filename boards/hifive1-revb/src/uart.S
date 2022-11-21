/****************************************************************************
 *
 *   Copyright (c) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";
.include "inc/mmap.inc" /* To get UART Base Address */
.include "inc/uart.inc"  /** UART register offsets */

/* Make utility functions visible to app */
.global uart1_set_115200;
.global uart1_set_txwmark;
.global uart1_set_rxwmark;
.global uart1_set_stopbits;
.global uart1_send_byte;
.global uart1_receive_byte;
.global uart1_enable_tx;
.global uart1_enable_rx;
.global uart1_disable;
.global uart1_enable_txwm_intr;
.global uart1_enable_rxwm_intr;

/* Function to set UART 1 baud rate to 115200
    Input: None
    Output: None */

Lalign4 uart1_set_115200:
    /* With tlclk at 16Mhz, to achieve 115200 baud,
    divisor should be 138 */

    li t0, UART1_BASE;
    li t1, 138;

    sw t1, UART_BAUD_DIV_OFFSET(t0);
ret;

/* Function to set tx water mark in UART 1
    Input: a0 - Transmit water mark level value 0-7
    Output: None */

Lalign4 uart1_set_txwmark:

    li t0, UART1_BASE;
    lhu t1, UART_TXCTRL_OFFSET+2(t0); /* Read present value */

    andi t1, t1, -8;
    or t1, t1, a0;
    sh t1, UART_TXCTRL_OFFSET+2(t0); /* Set wmark */

ret;

/* Function to set rx water mark in UART 1
    Input: a0 - Transmit water mark level value 0-7
    Output: None */

Lalign4 uart1_set_rxwmark:

    li t0, UART1_BASE;
    lhu t1, UART_RXCTRL_OFFSET+2(t0); /* Read present value */

    andi t1, t1, -8;
    or t1, t1, a0;
    sh t1, UART_RXCTRL_OFFSET+2(t0); /* Set wmark */

ret;

/* Function to set the number of stop bits in UART 1
    Input: a0- can be either 1 (2 stop bits) or 0 (1 stop bit)
    Output: None */

Lalign4 uart1_set_stopbits:

    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    slli a0, a0, 1;  /* shift input to stop bit position */
    or t1, t1, a0;   /* set stop bit count */
    sw t1, UART_TXCTRL_OFFSET(t0); /* Store back */

ret;

/* Function to enable UART 1 tx
    Input: None
    Output: None */

Lalign4 uart1_enable_tx:

    /* bit[0]: 0 - disable, 1 - enable */

    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    ori t1, t1, 1;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Enable */

ret;

Lalign4 uart1_enable_rx:

    /* bit[0]: 0 - disable, 1 - enable */

    li t0, UART1_BASE;
    lw t1, UART_RXCTRL_OFFSET(t0); /* Read present value */

    ori t1, t1, 1;
    sw t1, UART_RXCTRL_OFFSET(t0); /* Enable */
ret;

/* Function to disable UART 1
    Input: None
    Output: None */

Lalign4 uart1_disable:

    /* bit[0]: 0 - disable, 1 - enable */

    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    andi t1, t1, -2;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Disable */

ret;

/* Function to send a byte through UART 1 */
Lalign4 uart1_send_byte:
    /* Elementary function to send a byte
     Input: a0 with input byte in [7:0] bits
     Outpu: None */

      li t0, UART1_BASE;
      sw a0, UART_TXDATA_OFFSET(t0);

ret;

/* Function to receive a byte through UART 1 */
Lalign4 uart1_receive_byte:
    /* Elementary function to receive a byte
    Input: None
    Output: a0 with input byte in [7:0] bits */

    li t0, UART1_BASE;
    lw a0, UART_RXDATA_OFFSET(t0);

ret;

/* Function enables UART 1 tx water mark interrupt
    Input: None
    Output: None */

Lalign4 uart1_enable_txwm_intr:

    /* bit[0]: 0 - disable txwm, 1 - enable txwm interrupt */

    li t0, UART1_BASE;
    lw t1, UART_INTR_EN_OFFSET(t0); /* Read present value */

    ori t1, t1, 1;
    sw t1, UART_INTR_EN_OFFSET(t0); /* Enable */

ret;

/* Function enables UART 1 rx water mark interrupt
   Input: None
   Output: None */

Lalign4 uart1_enable_rxwm_intr:

    /* bit[1]: 0 - disable rxwm, 1 - enable rxwm interrupt */

    li t0, UART1_BASE;
    lw t1, UART_INTR_EN_OFFSET(t0); /* Read present value */

    ori t1, t1, 2;
    sw t1, UART_INTR_EN_OFFSET(t0); /* Enable */

ret;

