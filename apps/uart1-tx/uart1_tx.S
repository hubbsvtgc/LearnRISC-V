
/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text
.global app_entry;

.equiv GPIO18, 0x00040000 /* UART1 TX */
.equiv GPIO23, 0x00800000 /* UART1 RX */

.equiv UART1_INTERRUPT_SRC, 4

.p2align 2
app_entry:

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

    li a0, GPIO18;
    call gpio_set_as_iof;

    li a0, GPIO18;
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

    /* set 2 stop bits */
    li a0, 1;
    call uart1_set_stopbits; 

    /* Enable uart 1 tx water mark interrupt*/
    li a0, 1;
    call uart1_enable_txwm_intr;

    /* send byte 0xfc */
    li a0, 0xfc;
    call uart1_send_byte;

    /* send byte 0xf0 */
    li a0, 0xf0;
    call uart1_send_byte;

    /* send byte 0xc0 */
    li a0, 0xc0;
    call uart1_send_byte;

    /* Enable UART 1 */
    call uart1_enable_tx;

.p2align 2
    LB_loop_tx_start:

    li a0, 0xbc;
    call uart1_send_byte;
    j LB_loop_tx_start;
     
.p2align 2
    LB_loop_tx_end:
