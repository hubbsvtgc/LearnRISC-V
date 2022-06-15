/****************************************************************************
 *
 *  Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *  Author: Vincent <bsvtgc@gmail.com>
 *
 *  Platform-Level Interrupt Controller (PLIC)
 ****************************************************************************/
.section .text

/* Make functions visible outside */
.global FN_plic_set_priority;
.global FN_plic_enable_src;
.global FN_plic_set_threshold;

.include "RV_PLIC.S" /** From RISC-V Spec */
.include "fe310_mmap_h.S" /* FE310 Mmap */

/******************************
 * FUNCTION to set priority for interrupt sources
 * source in a0 register,
 * prority in a1 register 
 *****************************/
.p2align 2
FN_plic_set_priority:

    /* Interrupt priority levels 7
    * Bits 2:0
    * 0 - never interrupt/disables interrupt
    * 1 - lowest active priority
    * 7 - highest priority
    * Tie between sources of same priority - resolved
    * by Interrupt ID. lowest ID highest effective priority */

    /* Write a1 into (MMAP_BASE + 4*src id + PRIORITY OFFSET ) */

    li t0, FE310_PLICMMAP_BASE;
    slli a0, a0, 2;
    add t0, a0, t0;
    sw a1, PLIC_PRORITY_OFFSET(t0);

 ret;

/*******************************************
* FUNCTION to enable a source interrupt in PLIC CORE.
* Argument: Register a0 with interrupt src id
********************************************/
.p2align 2
FN_plic_enable_src:

    /* Interrupt sources
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

    /*************************************************
     count of 32: x in input source id a0 = mod(a0, 32).
     Enable bits register offset to source = x * 4
     Bit position in enable bit register is a0 - (x * 32)
     ****************************************************/

    srli t0, a0, 5; /* t0 -> x */

    slli t1, t0, 2;

    li t2, FE310_PLICMMAP_BASE;

    add t1, t1, t2;

    li t2, PLIC_ENABLE_OFFSET;

    add t1, t1, t2; /* t1 -> enable register addr */

    slli t2, t0, 5;

    sub t0, a0, t2;

    li t2, 1;
    sll t2, t2, t0; /* t2 -> value to be written to enable bit */

    sw t2, 0(t1);

ret;

/*******************************************
* FUNCTION to set priority threshold per target.
* Argument: Register a0 with target/context,
* Register a1 with threshold value
********************************************/
.p2align 2
FN_plic_set_threshold:

    /* FE310 has only one, HART 0 M-Mode context */

    li t0, FE310_PLICMMAP_BASE;
    li t1, PLIC_THRESHOLD_OFFSET;
    add t1, t1, t0;

    sw a1, 0(t1);

ret;

