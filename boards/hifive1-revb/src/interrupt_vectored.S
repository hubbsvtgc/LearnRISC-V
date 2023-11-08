/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
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
.globl intr_enable_mtimer;

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

/* Funtion to enable machine interrupt and
 * machine external interrupt */
Lalign4 intr_enable_mtimer:

   /* Read MIE csr and set bit 11 to enable external
    * interrupt */

    csrr t0, mie;

    li t1, MIE_MTIE;
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

Lalign4 invalid_src0_ihandler:
Lalign4 aon_wdog_ihandler:
Lalign4 aon_rtc_ihandler:
Lalign4 uart0_ihandler:
.ifdef UART1_DEFAULT_IHANDLER;
 Lalign4 uart1_ihandler:
.endif
Lalign4 qspi0_ihandler:
Lalign4 spi1_ihandler:
Lalign4 spi2_ihandler:
Lalign4 gpio0_ihandler:
Lalign4 gpio1_ihandler:
Lalign4 gpio2_ihandler:
Lalign4 gpio3_ihandler:
Lalign4 gpio4_ihandler:
Lalign4 gpio5_ihandler:
Lalign4 gpio6_ihandler:
Lalign4 gpio7_ihandler:
Lalign4 gpio8_ihandler:
Lalign4 gpio9_ihandler:
Lalign4 gpio10_ihandler:
Lalign4 gpio11_ihandler:
Lalign4 gpio12_ihandler:
Lalign4 gpio13_ihandler:
Lalign4 gpio14_ihandler:
Lalign4 gpio15_ihandler:
Lalign4 gpio16_ihandler:
Lalign4 gpio17_ihandler:
Lalign4 gpio18_ihandler:
Lalign4 gpio19_ihandler:
Lalign4 gpio20_ihandler:
Lalign4 gpio21_ihandler:
Lalign4 gpio22_ihandler:
Lalign4 gpio23_ihandler:
Lalign4 gpio24_ihandler:
Lalign4 gpio25_ihandler:
Lalign4 gpio26_ihandler:
Lalign4 gpio27_ihandler:
Lalign4 gpio28_ihandler:
Lalign4 gpio29_ihandler:
Lalign4 gpio30_ihandler:
Lalign4 gpio31_ihandler:
Lalign4 pwm0_ihandler:
Lalign4 pwm1_ihandler:
Lalign4 pwm2_ihandler:
Lalign4 i2c_ihandler:

    j default_ihandler;
    nop;

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
    nop;



Lalign4 exception_handler: /* Synchronous Exception handler */ 
    /* Do somehting to handle ecall if ecall */
    nop;

Lalign4 intr_reserved:  /* SHOULD NOT occur */
Lalign4 software_m_interrupt: /* Interrupt cause 3, machine sw interrupt */
Lalign4 timer_m_interrupt: /* Interrupt cause 7, machine timer interrupt */

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


.section .text
Lalign64 trap_base:
excep_intr_cause0:   j exception_handler; /* Sync exceptions jump to base address */

Lalign4 intr_cause1:
    j intr_reserved;  /* reserved in fe310-g002 */

Lalign4 intr_cause2:
    j intr_reserved;  /* reserved in fe310-g002 */

Lalign4 intr_cause3:
    j software_m_interrupt;  /* machine software interrupt */

Lalign4 intr_cause4:
    j intr_reserved;  /* reserved in fe310-g002 */

Lalign4 intr_cause5:
    j intr_reserved;  /* reserved in fe310-g002 */

Lalign4 intr_cause6:
    j intr_reserved;  /* reserved in fe310-g002 */

Lalign4 intr_cause7:
.ifdef MTIMER_APP_IHANDLER
    j timer_m_apphandler;  /* machine timer interrupt */
.else
    j timer_m_interrupt ;
.endif

Lalign4 intr_cause8:
    j intr_reserved;  /* reserved in fe310-g002 */

Lalign4 intr_cause9:
    j intr_reserved;  /* reserved in fe310-g002 */

Lalign4 intr_cause10:
    j intr_reserved;  /* reserved in fe310-g002 */

Lalign4 intr_cause11:
    j external_m_interrupt;  /* reserved in fe310-g002 */

.endif
