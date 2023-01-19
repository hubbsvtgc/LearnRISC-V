.include "inc/macros.inc";

.globl app_entry;

Lalign4 app_entry:

    call led_blink_init;
    nop;
    call uart_tx_init;

j .
