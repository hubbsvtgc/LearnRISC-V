/****************************************************************************
 *
 *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/
 
 .ifndef _HIFIVE1_REVB_SRC_INC_CONFIG_INC_

 .equiv _HIFIVE1_REVB_SRC_INC_CONFIG_INC_, 1

.equiv INTERRUPT_VECTOR_MODE, 1 
/* .equiv INTERRUPT_DIRECT_MODE, 1 */

.equiv HFCLK_TLCLK, 16000000  /* 16 Mhz is the hfclk at reset */

.equiv UART1_DEFAULT_IHANDLER, 1
.equiv MTIMER_APP_IHANDLER, 1

.endif

