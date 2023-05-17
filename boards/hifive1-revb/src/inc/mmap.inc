
/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.ifndef _HIFIVE1_REVB_SRC_INC_MMAP_INC_
.equiv _HIFIVE1_REVB_SRC_INC_MMAP_INC_, 1

.equiv CLINT_BASE,0x02000000 /* CLINT Base Address */
.equiv PLIC_BASE, 0x0C000000 /* Implementation specific */
.equiv AON_BASE,  0x10000000 /* AON Base Address */
.equiv GPIO_BASE, 0x10012000 /* GPIO Base address */
.equiv UART0_BASE,0x10013000 /* UART0 Base Address */
.equiv UART1_BASE,0x10023000 /* UART1 Base Address */
.equiv SPI1_BASE, 0x10024000 /* SPI 1 Base Address */
.equiv SPI2_BASE, 0x10034000 /* SPI 2 Base Address */

.endif

