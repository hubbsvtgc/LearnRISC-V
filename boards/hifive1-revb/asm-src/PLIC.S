/****************************************************************************
 *
 *  Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *  Author: Vincent <bsvtgc@gmail.com>
 *
 *  Platform-Level Interrupt Controller (PLIC)
 ****************************************************************************/
.section .text

/* Enable source id in PLIC */
.global FN_plic_enable_src_id;

/********************************************
 * PLIC in FE310-G002 supports 52 interrupt sources 
 * with 7 priority levels 
 * Interrupt sources 
 * AON (start 1, end 2)
 * aon_wdt plic source id 1 (bit pos 1),
 * aon_rtc plic source id 2 
 * UART (start 3, end 4)
 * uart0 plic source id 3,
 * uart1 plic source id 4 
 * SPI (start 5, end 7)
 * qspi0 plic source id 5,
 * spi1 plic source id 6,
 * spi2 plic source id 7 
 * GPIO (start 8, end 39)
 * gpio0 plic source id 8, (bit pos 8)
 * gpio1 plic source id 9,
 * ...
 * gpio23 plic source id 23, (bit pos 31)
 * UPPER REGISTER WORD
 * gpio24 plic source id 32 (bit pos 0)
 * ...
 * gpio31 plic source id 39 (bit pos 31) 
 **************************************/

/* Argument: Register a0 with interrupt src id*/

FN_plic_enable_src_id: 

/* PLIC, HART 0, M MODE interrupt enable register1,
 * bit 0, hardwired to 0, interrupt src 1 to 31
 * Interrupt source from 32 to 52 PLIC_INTR_EN2, 0x0C002004 */

.equiv PLIC_INTR_EN1, 0x0C002000

    li t0, PLIC_INTR_EN1;

.equiv K_SRCID_31, 31

    li t1, K_SRCID_31;

    /* Register a0 has the src id*/
    blt a0, t1, LB_plic_srcid_lt31;

    /* > 31, set (a0-31) bit on EN2 reg */
    addi a0, a0, -31;
    addi t0, t0, 4;

LB_plic_srcid_lt31:

   /* Enable 1 << (a0) bit on ENx register*/
    li t1, 1;
    sll t1, t1, a0;

    lw t2, 0(t0);
    or t2, t2, t1;
    sw t2, 0(t0);
ret;

/* Interrupt priority levels 7
 * Bits 2:0 
 * 0 - never interrupt/disables interrupt
 * 1 - lowest active priority
 * 7 - highest priority
 * Tie between sources of same priority - resolved
 * by Interrupt ID. lowest ID highest effective priority */


