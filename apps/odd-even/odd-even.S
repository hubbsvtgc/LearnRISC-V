
.include "inc/macros.inc";
.globl app_entry;

Lalign4 app_entry:

# dividend = divisor * quotient + reminder         ( -200 = -40 * 5 + 0)

addi t0, zero, -200 # Dividend
addi t1, zero, 40  # Divisor

divu a0, t0, t1    # Quotient
remu a1, t0, t1    # Reminder

nop;
nop;

