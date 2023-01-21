
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";

.equiv GPIO18, 0x00040000 /*UART1 Tx */
.equiv UART1_INTERRUPT_SRC, 4

.global uart_tx_init;

Lalign4 uart_tx_init:

    /* Configure GPIO18 as UART1 TX */

    li a0, GPIO18;
    call gpio_set_as_iof;

    li a0, GPIO18;
    call gpio_select_iof;

    /* set UART 1 to baud 115200 */
    call uart1_set_115200;

    /* set 2 stop bits */
    li a0, 1;
    call uart1_set_stopbits; 

    /* send byte 0xc0 */
    li a0, 0xc0;
    call uart1_send_byte;

    /* Enable UART 1 Tx*/
    call uart1_enable_tx;

Lalign4 uart_tx_init_end:
ret;

nop;
Lalign4 uart_tx_loop_start:
    li a0, 0xbc;
    call uart1_send_byte;
    j uart_tx_loop_start;
Lalign4 uart_tx_loop_end:
