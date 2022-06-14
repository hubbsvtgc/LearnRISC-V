
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text
.global FN_app_entry;

.equiv GPIO18_UART1_TX, 0x00040000
.equiv GPIO23_UART1_RX, 0x00800000

.equiv UART1_INTERRUPT_SRC, 4

.p2align 2
FN_app_entry:

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

    li a0, GPIO18_UART1_TX;
    call FN_gpio_configure_as_iof;

    li a0, GPIO23_UART1_RX;
    call FN_gpio_configure_as_iof;

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
    call FN_uart1_set_115200;

    /* set UART 1 tx water mark to 3 */
    li a0, 3;
    call FN_uart1_set_txwmark;

    /* set 2 stop bits */
    li a0, 1;
    call FN_uart1_set_stopbits;

    /* send byte 0xaa */
    li a0, 0xaa;
    call FN_uart1_send_byte;

    /* send byte 0xaa */
    li a0, 0xaa;
    call FN_uart1_send_byte;

    /* send byte 0xaa */
    li a0, 0xaa;
    call FN_uart1_send_byte;

    /* Enable UART 1 */
    call FN_uart1_enable;

    LB_loop_tx_start:

        li a0, 0xaa;
        call FN_uart1_send_byte;

    LB_loop_tx_end:

    
