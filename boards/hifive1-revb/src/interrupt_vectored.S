/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.include "inc/config.inc"  /** Build Configuration */

.ifdef INTERRUPT_VECTOR_MODE

.include "inc/mmap.inc"  /** FE310 Mmap */
.include "inc/csr.inc"  /** RISC-V csr constants */
.include "plic_spec.inc" /** From RISC-V plic Spec */
.include "inc/uart.inc"  /** UART register offsets */
.include "inc/macros.inc"  /** Assembly macros */

.globl trap_base;
.globl FN_intr_enable_mexternal;

.section .text

Lalign4 LB_intr_src29_gpio21:

    sw ra, 0(sp);
    sw a0, 4(sp);
    sw t0, 8(sp);
    sw t1, 12(sp);
    addi sp, sp, 16;

    li a0, 0x00200000;
    call FN_gpio_clear_rise_pend;

    addi sp, sp, -16;
    lw ra, 0(sp);
    lw a0, 4(sp);
    lw t0, 8(sp);
    lw t1, 12(sp);

mret;

/* Funtion to enable machine interrupt and
 * machine external interrupt */
Lalign4 FN_intr_enable_mexternal:

   /* Read MIE csr and set bit 11 to enable external
    * interrupt */

    csrr t0, mie;

    li t1, MIE_MEIE;
    or t0, t0, t1;

    csrw mie, t0;

    /* Read MSTATUS csr and set bit 3
    to enable machine interrupt */

    csrr t0, mstatus;

    li t1, MSTATUS_MIE;
    or t0, t0, t1;

    csrw mstatus, t0;

 ret;

Lalign4 default_ihandler:
mret; /* NOTE: it should be MRET */

invalid_src0_ihandler:
aon_wdog_ihandler:
aon_rtc_ihandler:
uart0_ihandler:
uart1_ihandler:
qspi0_ihandler:
spi1_ihandler:
spi2_ihandler:
gpio0_ihandler:
gpio1_ihandler:
gpio2_ihandler:
gpio3_ihandler:
gpio4_ihandler:
gpio5_ihandler:
gpio6_ihandler:
gpio7_ihandler:
gpio8_ihandler:
gpio9_ihandler:
gpio10_ihandler:
gpio11_ihandler:
gpio12_ihandler:
gpio13_ihandler:
gpio14_ihandler:
gpio15_ihandler:
gpio16_ihandler:
gpio17_ihandler:
gpio18_ihandler:
gpio19_ihandler:
gpio20_ihandler:
gpio21_ihandler:
gpio22_ihandler:
gpio23_ihandler:
gpio24_ihandler:
gpio25_ihandler:
gpio26_ihandler:
gpio27_ihandler:
gpio28_ihandler:
gpio29_ihandler:
gpio30_ihandler:
gpio31_ihandler:
pwm0_ihandler:
pwm0_ihandler:
pwm0_ihandler:
pwm0_ihandler:
pwm1_ihandler:
pwm1_ihandler:
pwm1_ihandler:
pwm1_ihandler:
pwm2_ihandler:
pwm2_ihandler:
pwm2_ihandler:
pwm2_ihandler:
i2c_ihandler:

    j default_ihandler;


Lalign4 plic_vect_table:
Lalign4 plic_src0: 
    j invalid_src0_ihandler;
Lalign4 plic_src1: 
    j aon_wdog_ihandler;
Lalign4 plic_src2: 
    j aon_rtc_ihandler;
Lalign4 plic_src3: 
    j uart0_ihandler;
Lalign4 plic_src4: 
    j uart1_ihandler; 
Lalign4 plic_src5: 
    j qspi0_ihandler;
Lalign4 plic_src6: 
    j spi1_ihandler;
Lalign4 plic_src7: 
    j spi2_ihandler;

/* gpio */
Lalign4 plic_src8: 
    j gpio0_ihandler;
Lalign4 plic_src9: 
    j gpio1_ihandler;
Lalign4 plic_src10: 
    j gpio2_ihandler;
Lalign4 plic_src11: 
    j gpio3_ihandler;
Lalign4 plic_src12: 
    j gpio4_ihandler;
Lalign4 plic_src13: 
    j gpio5_ihandler;
Lalign4 plic_src14: 
    j gpio6_ihandler;
Lalign4 plic_src15: 
    j gpio7_ihandler;
Lalign4 plic_src16: 
    j gpio8_ihandler;
Lalign4 plic_src17: 
    j gpio9_ihandler;
Lalign4 plic_src18: 
    j gpio10_ihandler;
Lalign4 plic_src19: 
    j gpio11_ihandler;
Lalign4 plic_src20: 
    j gpio12_ihandler;
Lalign4 plic_src21: 
    j gpio13_ihandler;
Lalign4 plic_src22: 
    j gpio14_ihandler;
Lalign4 plic_src23: 
    j gpio15_ihandler;
Lalign4 plic_src24: 
    j gpio16_ihandler;
Lalign4 plic_src25: 
    j gpio17_ihandler;
Lalign4 plic_src26: 
    j gpio18_ihandler;
Lalign4 plic_src27: 
    j gpio19_ihandler;
Lalign4 plic_src28: 
    j gpio20_ihandler;
Lalign4 plic_src29: 
    j LB_intr_src29_gpio21;
Lalign4 plic_src30: 
    j gpio22_ihandler;
Lalign4 plic_src31: 
    j gpio23_ihandler;
Lalign4 plic_src32: 
    j gpio24_ihandler;
Lalign4 plic_src33: 
    j gpio25_ihandler;
Lalign4 plic_src34: 
    j gpio26_ihandler;
Lalign4 plic_src35: 
    j gpio27_ihandler;
Lalign4 plic_src36: 
    j gpio28_ihandler;
Lalign4 plic_src37: 
    j gpio29_ihandler;
Lalign4 plic_src38: 
    j gpio30_ihandler;
Lalign4 plic_src39: 
    j gpio31_ihandler;

Lalign4 plic_src40: 
    j pwm0_ihandler;
Lalign4 plic_src41: 
    j pwm0_ihandler;
Lalign4 plic_src42: 
    j pwm0_ihandler;
Lalign4 plic_src43: 
    j pwm0_ihandler;

Lalign4 plic_src44: 
    j pwm1_ihandler;
Lalign4 plic_src45: 
    j pwm1_ihandler;
Lalign4 plic_src46: 
    j pwm1_ihandler;
Lalign4 plic_src47: 
    j pwm1_ihandler;

Lalign4 plic_src48: 
    j pwm2_ihandler;
Lalign4 plic_src49: 
    j pwm2_ihandler;
Lalign4 plic_src50: 
    j pwm2_ihandler;
Lalign4 plic_src51: 
    j pwm2_ihandler;

Lalign4 plic_src52: 
    j i2c_ihandler;



exception_handler: /* Synchronous Exception handler */ 
intr_reserved:  /* SHOULD NOT occur */
software_m_interrupt: /* Interrupt cause 3, machine sw interrupt */
timer_m_interrupt: /* Interrupt cause 7, machine timer interrupt */
mret;

Lalign4 external_m_interrupt: /* Interrupt cause 11, external interrupt */

/* read the interrupt source and jump to corresponding handler */

li t0, PLIC_BASE;
li t1, PLIC_CLAIMCOMP_CTX1_OFFSET;
add t0, t1, t0;

lw t1, 0(t0);
sw t1, 0(t0);
slli t1, t1, 2;

lui t0, %hi(plic_vect_table);
addi t0, t0, %lo(plic_vect_table);

add t1, t1, t0;
jr t1;  /* j plic_vect_table + interrupt src x 4 */


.section .mtvec_table
Lalign64 trap_base:
excep_intr_cause0:   j exception_handler; /* Sync exceptions jump to base address */

intr_cause1:   j intr_reserved;  /* reserved in fe310-g002 */
intr_cause2:   j intr_reserved;  /* reserved in fe310-g002 */

intr_cause3:   j software_m_interrupt;  /* machine software interrupt */

intr_cause4:   j intr_reserved;  /* reserved in fe310-g002 */
intr_cause5:   j intr_reserved;  /* reserved in fe310-g002 */
intr_cause6:   j intr_reserved;  /* reserved in fe310-g002 */

intr_cause7:   j timer_m_interrupt;  /* machine timer interrupt */

intr_cause8:   j intr_reserved;  /* reserved in fe310-g002 */
intr_cause9:   j intr_reserved;  /* reserved in fe310-g002 */
intr_cause10:  j intr_reserved;  /* reserved in fe310-g002 */

intr_cause11:  j external_m_interrupt;  /* reserved in fe310-g002 */

.endif
