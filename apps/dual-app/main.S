.include "inc/macros.inc";

.globl app_entry;

Lalign4 app_entry:

    call blink_init;
    nop;
    call uart_tx_init;
    nop;
    call timer_init;

j .
