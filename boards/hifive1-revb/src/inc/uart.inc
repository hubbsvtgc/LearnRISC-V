
/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.ifndef _HIFIVE1_REVB_SRC_INC_UART_INC_
.equiv _HIFIVE1_REVB_SRC_INC_UART_INC_, 1

.equiv UART1_INTERRUPT_SRC, 4

.equiv UTXDATA_OFFSET, 0x00
.equiv URXDATA_OFFSET, 0x04
.equiv UTXCTRL_OFFSET, 0x08
.equiv URXCTRL_OFFSET, 0x0C
.equiv UINTR_EN_OFFSET, 0x10
.equiv UINTR_PEND_OFFSET, 0x14
.equiv UBAUD_DIV_OFFSET, 0x18

.endif
