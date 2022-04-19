/****************************************************************************
 *
 *   Copyright (c) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.equiv UART0_INSTANCE, 0
.equiv UART1_INSTANCE, 1

.equiv UART0_BASE, 0x10013000
.equiv UART1_BASE, 0x10023000

.equiv UART_TXDATA_OFFSET, 0x00
.equiv UART_TXCTRL_OFFSET, 0x08

.equiv UART_RXDATA_OFFSET, 0x04
.equiv UART_RXCTRL_OFFSET, 0x0C

.equiv UART_INTR_EN_OFFSET, 0x10
.equiv UART_INTR_PEND_OFFSET, 0x14

.equiv UART_BAUD_DIV_OFFSET, 0x18



.global _uart0_set_115200;

_uart0_set_115200:
    /* Do the needful to set UART 0 at 115200 */

ret;

_uart0_send_byte:
    /* Elementary function to send a byte
     Input: a0 with input byte in [7:0] bits */

ret:
