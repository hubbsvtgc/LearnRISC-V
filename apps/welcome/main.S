.include "inc/macros.inc";
.include "inc/mmap.inc";
.include "inc/clint.inc";
.include "inc/csr.inc";

/* Mtimer is counted by rtclk, which is 32.768 khz */

.equiv ONE_SEC, 0x8000 /* 32768 in hex */
.equiv FIVE_SEC, 0x28000 /* 32768 * 5 in hex */
.equiv ONE_MIN, 0x1E0000 /* 32768 * 60 in hex */

.globl timer_m_apphandler;
.globl app_entry;

Lalign4 app_entry:

    nop;

    call blink_init;
    nop;
    call uart_tx_init;
    nop;

    /* Enable Machine Timer Interrupt */

    li t0, MIE_MTIE;
    csrw mie, t0;

    li t0, MSTATUS_MIE;
    csrw mstatus, t0;

    /* Clear mtime */

    li t0, CLINT_BASE;
    li t1, MTIME_OFF; 
    add t0, t0, t1;
    sw zero, 0(t0);
    sw zero, 4(t0); /* 64 bit register */

    /* Set timer interrupt duration */
    li t0, CLINT_BASE;
    li t1, MTIMECMP_OFF; 
    add t0, t0, t1;

    li t2, FIVE_SEC;
    sw t2, 0(t0);
    sw zero, 4(t0); /* 64 bits register */

    /* Flag to switch apps in m handler */
    li s0, 0;

j .

timer_m_apphandler:

    nop;

    /* Set timer interrupt duration */
    li t0, CLINT_BASE;
    li t1, MTIMECMP_OFF;
    add t0, t0, t1;
    lw t2, 0(t0);
    li t3, FIVE_SEC;
    add t2, t2, t3;
    sw t2, 0(t0);
    sw zero, 4(t0); /* 64 bits register */

bnez s0, j_uart;
    la t0, blink_loop;
    csrw mepc, t0;
    addi s0, s0, 1;
mret;
j_uart:
    nop;
    la t0, uart_tx_loop_start;
    csrw mepc, t0;
    addi s0, s0, -1;
mret;
