/****************************************************************************
 *
 *   Copyright (c) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.equiv UART1_BASE, 0x10023000

.equiv UART_TXDATA_OFFSET, 0x00
.equiv UART_RXDATA_OFFSET, 0x04
.equiv UART_TXCTRL_OFFSET, 0x08
.equiv UART_RXCTRL_OFFSET, 0x0C
.equiv UART_INTR_EN_OFFSET, 0x10
.equiv UART_INTR_PEND_OFFSET, 0x14
.equiv UART_BAUD_DIV_OFFSET, 0x18

/* Make utility functions visible to app */
.global FN_uart1_set_115200;
.global FN_uart1_set_txwmark;
.global FN_uart1_set_stopbits;
.global FN_uart1_send_byte;
.global FN_uart1_enable;
.global FN_uart1_disable;

/* Function to set UART 1 baud rate to 115200 */
FN_uart1_set_115200:
    /* With tlclk at 16Mhz, to achieve 115200 baud,
    divisor should be 512*/

    li t0, UART1_BASE;
    li t1, 512;

    sw t1, UART_BAUD_DIV_OFFSET(t0);
ret;

/* Function to set tx water mark in UART 1 */
FN_uart1_set_txwmark:
    /* Args- a0 - Transmit water mark level value 0-7*/

    slli a0, a0, 15;
    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

.equiv UART_MASK_WMARK, 0xFFF8FFFF /* [18:16] zero mask */

    li t2, UART_MASK_WMARK;
    add t1, t1, t2;
    or t1, t1, a0;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Set wmark */
ret;

/* Function to set the number of stop bits in UART 1 */
FN_uart1_set_stopbits:
    /* Args- a0 - Number of stop bits
     0 - 1 stop bit, 1 -  2 stop bits */

    slli a0, a0, 1;
    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

.equiv UART_MASK_STOPBITS, 0xFFFFFFFD /* [1] bit zero mask */

    li t2, UART_MASK_STOPBITS;
    add t1, t1, t2;
    or t1, t1, a0;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Set wmark */
ret;

/* Function to send a byte through UART 1 */
FN_uart1_send_byte:
    /* Elementary function to send a byte
     Input: a0 with input byte in [7:0] bits */

ret:

/* Function to enable UART 1 */
FN_uart1_enable:

    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    ori t1, t1, 1;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Enable */

ret;

/* Function to disable UART 1 */
FN_uart1_disable:

    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    xori t1, t1, 1;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Disable */

ret;
