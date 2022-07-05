
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.global FN_trap_routine;

.section .text

.equiv INTERRUPT_MASK, 0x80000000
.equiv EXCEPTION_CODE_MASK, 0x7FFFFFFF
.equiv EXT_INTR_BIT, 0x8
.equiv MACHINE_SI_MASK, 0x3
.equiv MACHINE_TI_MASK, 0x7
.equiv MACHINE_EI_MASK, 0xb

.include "fe310_mmap_h.S"  /** FE310 Mmap */
.include "RV_PLIC.S" /** From RISC-V Spec */
.include "fe310_uart_h.S"  /** UART register offsets */

uart1_rec_addr: .word 0x80003000;

.p2align 2

/* Trap vector base address should be aligned on 4-byte boundary 
 * this dont take any argument */
FN_trap_routine:
    /* Back up ra, a0, t0, t1 registers */
    sw ra, 0(sp);
    sw a0, 4(sp);
    sw t0, 8(sp);
    sw t1, 12(sp);

    csrr t0, mcause;

    li t0, FE310_PLICMMAP_BASE;
    li t1, PLIC_CLAIMCOMP_CTX1_OFFSET;
    add t0, t1, t0; /* t0 has the claim/comp reg addr */

    lw t1, 0(t0);
    andi t1, t1, 63; /* Interrupt source in t1 */

    li t2, 4;
    beq t2, t1, LB_uart1_intr;

    /* HACK: if not uart1, for gpio21 interrupt */
    j LB_gpio21_intr;

.p2align 2
LB_uart1_intr: /* Uart1 interrupt */

    /* if uart tx [bit:0] wm interrupt transmit a byte */

    li a0, UART1_BASE;
    lw t0, UART_INTR_PEND_OFFSET(a0);

    andi t0, t0, 1;
    li t1, 1;
    bne t0, t1, LB_trap_uart_rx_check;

    LB_trap_uart1_tx:
    li a0, 0xcb;
    call FN_uart1_send_byte;

LB_trap_uart_rx_check:

    /* if uart rx [bit:1] wm interrupt receive a byte */

    li a0, UART1_BASE;
    lw t0, UART_INTR_PEND_OFFSET(a0);

    andi t0, t0, 2;
    li t1, 2;
    bne t0, t1, LB_trap_routine_end;

    call FN_uart1_receive_byte; /* received byte is in a0 */

    lw t0, uart1_rec_addr;
    sw a0, 0(t0); /* Write the recived data from RECEIVE_START_ADDR */

j LB_trap_routine_end;

.p2align 2
LB_gpio21_intr: /* Gpio21 interrupt */

    li a0, 0x00200000;
    call FN_gpio_clear_rise_pend;

.p2align 2
LB_trap_routine_end:

    li t0, FE310_PLICMMAP_BASE;
    li t1, PLIC_CLAIMCOMP_CTX1_OFFSET;
    add t0, t1, t0; /* t0 has the claim/comp reg addr */

    sw t2, 0(t0); /* Write with any value means completion */

    /* Restore ra, a0, t0, t1 registers */

    lw ra, 0(sp);
    lw a0, 4(sp);
    lw t0, 8(sp);
    lw t1, 12(sp);

mret; /* NOTE: it should be MRET */


