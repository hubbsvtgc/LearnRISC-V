
/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

/* rec_addr: .word 0x80004000; */

.section .text

.include "inc/macros.inc";
.include "inc/mmap.inc"  /** FE310 Mmap */
.include "inc/uart.inc"  /** UART register offsets */
.include "inc/gpio.inc"

.global app_entry;
 .global uart1_ihandler; 

.equiv GPIO18_BMASK, 0x00040000
.equiv GPIO23_BMASK, 0x00800000

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

    li a0, GPIO18_BMASK;
     /* Perform bitwise OR operation */
    li t0, GPIO_BASE;
    lw t1, GPIO_IOF_EN_OFF(t0);
    or a0, t1, a0;
    sw a0, GPIO_IOF_EN_OFF(t0);

    li a0, GPIO23_BMASK;
     /* Perform bitwise OR operation */
    li t0, GPIO_BASE;
    lw t1, GPIO_IOF_EN_OFF(t0);
    or a0, t1, a0;
    sw a0, GPIO_IOF_EN_OFF(t0);

/*
    li a0, GPIO18_BMASK;
    call gpio_select_iof;

    li a0, GPIO23_BMASK;
    call gpio_select_iof; */

    /* Set priority 3 to uart1 interrupt source 4 */

    li a0, UART1_INTERRUPT_SRC;
    li a1, 3;
    call FN_plic_set_priority;

    li a1, 2; /* All interrupts upto priority 2 would be masked */
    call FN_plic_set_threshold;

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

    /* Enable uart 1 tx water mark interrupt */
    call uart1_enable_txwm_intr; 

    /* Enable uart 1 rx water mark interrupt*/
    call uart1_enable_rxwm_intr;

    /* send byte 0xc0 */
    li a0, 0xc0;
    call uart1_send_byte;

    /* Enable UART 1 Tx*/
    call uart1_enable_tx;

    /* Enable UART 1 Rx 
    call uart1_enable_rx;  */

    /* Enable external interrupt */
    call FN_intr_enable_mexternal; 

    nop;
    nop;

    j .

/**********************************
 *** UART 1 interrupt processing **
***********************************/

/* UART 1 INTERRUPT HANDLER */

Lalign4 uart1_ihandler:

    sw ra, 0(sp);
    sw a0, 4(sp);
    sw t0, 8(sp);
    sw t1, 12(sp);
    addi sp, sp, 16;

    li a0, UART1_BASE;
    lw t0, UART_INTR_PEND_OFFSET(a0);

    /* Extracts bits 0 & 1 process tx or rx or both tx and rx interrupts */

    andi t0, t0, 3; 
    andi t1, t0, 1;
    beqz t1, uart1_rx_;

Lalign4 uart1_tx_:
    nop;
    li t1, UART1_BASE;
    start_transmitting:
    nop;
    lw a0, UART_TXDATA_OFFSET(t1); 
    srli a0, a0, 31;
    bnez a0, tx_fifo_full; /* check bit 31 */
    li a0, 0xf0;
    sb a0, UART_TXDATA_OFFSET(t1); /* Uart1 tx pending bit is cleared if enqued upto wmark */
    j start_transmitting;
    nop;
    tx_fifo_full:
    nop;
    j uart1_txrx_end;
    nop;

Lalign4 uart1_rx_:
    andi t1, t0, 2;
    beqz t1, uart1_txrx_end;
    li t1, UART1_BASE;
    lw a0, UART_RXDATA_OFFSET(t1);
    nop;

Lalign4 uart1_txrx_end:

   /* csrr t0, mstatus;
     ori t0, t0, 8;
     csrw mstatus, t0; */

    addi sp, sp, -16;
    lw ra, 0(sp);
    lw a0, 4(sp);
    lw t0, 8(sp);
    lw t1, 12(sp);
    nop;
mret;
nop;
