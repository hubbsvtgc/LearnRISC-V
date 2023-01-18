
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

/* rec_addr: .word 0x80004000; */

.section .text

.include "inc/macros.inc";

.global app_entry;

.equiv GPIO18, 0x00040000
.equiv GPIO23, 0x00800000

.equiv UART1_INTERRUPT_SRC, 4

Lalign4 app_entry:

    /* Set all interrupt sources to priority 2 */

    li a0, 52; /* Max source id */
    li a1, 2; /* Prority */

    .p2align 2
    LB_apploop_start:

        beqz a0, LB_apploop_end;

        sw a0, 0(sp);
        sw a1, 4(sp);

        call FN_plic_set_priority;

        lw a0, 0(sp);
        lw a1, 4(sp);

        addi a0, a0, -1;
        j LB_apploop_start;

    .p2align 2
    LB_apploop_end:

    /* Configure pins as UART1 TX & RX */

    li a0, GPIO18;
    call gpio_set_as_iof;

    li a0, GPIO23;
    call gpio_set_as_iof;

    li a0, GPIO18;
    call gpio_select_iof;

    li a0, GPIO23;
    call gpio_select_iof;

    /* Set priority 3 to uart1 interrupt source 4 */

    li a0, UART1_INTERRUPT_SRC;
    li a1, 3;
    call FN_plic_set_priority;

    li a1, 2; /* All interrupts upto priority 2 would be masked */
    call FN_plic_set_threshold;

    /* Enable external interrupt */
    call FN_intr_enable_mexternal; 

    /* set source enable bits in PLIC */
    li a0, UART1_INTERRUPT_SRC;
    call FN_plic_enable_src;

    /* set UART 1 to baud 115200 */
    call uart1_set_115200;

    /* set UART1 tx water mark to 1 */
    li a0, 1;
    call uart1_set_txwmark;

    /* set UART1 rx water mark to 1 */
    li a0, 1;
    call uart1_set_rxwmark;

    /* set 2 stop bits */
    li a0, 1;
    call uart1_set_stopbits; 

    /* Enable uart 1 tx water mark interrupt
       call uart1_enable_txwm_intr; */

    /* Enable uart 1 rx water mark interrupt*/
    call uart1_enable_rxwm_intr;

    /* send byte 0xc0 */
    li a0, 0xc0;
    call uart1_send_byte;

    /* Enable UART 1 Tx*/
    call uart1_enable_tx;

    /* Enable UART 1 Rx*/
    call uart1_enable_rx;

.p2align 2
    LB_loop_tx_start:

    li a0, 0xbc;
    call uart1_send_byte;
    j LB_loop_tx_start;

.p2align 2
    LB_loop_tx_end:
