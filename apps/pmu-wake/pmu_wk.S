/****************************************************************************
 *
 *   Copyright (C) 2023 bsvtgc@gmail.com. All rights reserved.
 *   Author: Vincent <bsvtgc@gmail.com>
 *
 ****************************************************************************/

.section .text

.include "inc/macros.inc";
.include "inc/mmap.inc";
.include "inc/pmu.inc";

.globl app_entry;

Lalign4 delay: /* value passed in a0 */

Lalign4 delayloop_start:

    beqz a0, delayloop_end;
    addi a0, a0, -1;
    j delayloop_start;

Lalign4 delayloop_end:
ret;

Lalign4 app_entry:
nop;

Lalign4 loop_forever:
nop;

/* delay */
li a0, 0xfffff;
call delay;


# Unblock PMU 
li t0, AON_BASE;
li t1, PMU_KEY;
sw t1, PMU_KEY_OFST(t0); 

#set pmuie to 0
sw zero, PMU_IE_OFST(t0); 

# Unblock PMU 
sw t1, PMU_KEY_OFST(t0); 

#set to sleep - any value
li t1, 2;
sw t1, PMU_SLEEP_OFST(t0); 

/* delay */
li a0, 0xfffff;
call delay;

j .
