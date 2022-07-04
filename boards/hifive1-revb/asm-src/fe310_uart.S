/****************************************************************************
 *
 *   Copyright (c) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "fe310_mmap_h.S" /* To get UART Base Address */

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
.global FN_uart1_set_rxwmark;
.global FN_uart1_set_stopbits;
.global FN_uart1_send_byte;
.global FN_uart1_enable;
.global FN_uart1_disable;
.global FN_uart1_enable_txwm_intr;
.global FN_uart1_enable_rxwm_intr;

/* Function to set UART 1 baud rate to 115200 */
.p2align 2
FN_uart1_set_115200:
    /* With tlclk at 16Mhz, to achieve 115200 baud,
    divisor should be 138 */

    li t0, UART1_BASE;
    li t1, 138;

    sw t1, UART_BAUD_DIV_OFFSET(t0);
ret;

/* Function to set tx water mark in UART 1 */
.p2align 2
FN_uart1_set_txwmark:

    /* Args- a0 - Transmit water mark level value 0-7*/

    li t0, UART1_BASE;
    lhu t1, UART_TXCTRL_OFFSET+2(t0); /* Read present value */

    andi t1, t1, -8;
    or t1, t1, a0;
    sh t1, UART_TXCTRL_OFFSET+2(t0); /* Set wmark */

ret;

/* Function to set rx water mark in UART 1 */
.p2align 2
FN_uart1_set_rxwmark:

    /* Args- a0 - Transmit water mark level value 0-7*/

    li t0, UART1_BASE;
    lhu t1, UART_RXCTRL_OFFSET+2(t0); /* Read present value */

    andi t1, t1, -8;
    or t1, t1, a0;
    sh t1, UART_RXCTRL_OFFSET+2(t0); /* Set wmark */

ret;

/* Function to set the number of stop bits in UART 1
Input can be either 1 or 0*/

.p2align 2
FN_uart1_set_stopbits:
    /* Args- a0 - Number of stop bits 
    bit[1]: 0 - 1 stop bit, 1 - 2 stop bits */

    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    slli a0, a0, 1;  /* shift input to stop bit position */
    or t1, t1, a0;   /* set stop bit count */
    sw t1, UART_TXCTRL_OFFSET(t0); /* Store back */

ret;

/* Function to enable UART 1
NO input to this function */

.p2align 2
FN_uart1_enable:

    /* bit[0]: 0 - disable, 1 - enable */

    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    ori t1, t1, 1;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Enable */

ret;

/* Function to disable UART 1
No Input to this function */

.p2align 2
FN_uart1_disable:

    /* bit[0]: 0 - disable, 1 - enable */

    li t0, UART1_BASE;
    lw t1, UART_TXCTRL_OFFSET(t0); /* Read present value */

    andi t1, t1, -2;
    sw t1, UART_TXCTRL_OFFSET(t0); /* Disable */

ret;

/* Function to send a byte through UART 1 */
.p2align 2
FN_uart1_send_byte:
    /* Elementary function to send a byte
     Input: a0 with input byte in [7:0] bits */

      li t0, UART1_BASE;
      sw a0, UART_TXDATA_OFFSET(t0);

ret;

/* Function enables UART 1 tx water mark interrupt */

.p2align 2
FN_uart1_enable_txwm_intr:

    /* bit[0]: 0 - disable txwm, 1 - enable txwm interrupt */

    li t0, UART1_BASE;
    lw t1, UART_INTR_EN_OFFSET(t0); /* Read present value */

    ori t1, t1, 1;
    sw t1, UART_INTR_EN_OFFSET(t0); /* Enable */

ret;

/* Function enables UART 1 rx water mark interrupt */

.p2align 2
FN_uart1_enable_rxwm_intr:

    /* bit[1]: 0 - disable rxwm, 1 - enable rxwm interrupt */

    li t0, UART1_BASE;
    lw t1, UART_INTR_EN_OFFSET(t0); /* Read present value */

    ori t1, t1, 2;
    sw t1, UART_INTR_EN_OFFSET(t0); /* Enable */

ret;
