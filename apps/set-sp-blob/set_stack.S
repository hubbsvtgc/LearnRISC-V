
.include "inc/macros.inc";

.equiv STACK4K_RAMADDR, 0x80001000
.equiv FIXED_JUMPADDR,   0x20000100

.globl app_entry;

.section .text

Lalign4 app_entry:

    nop;
    la t1, STACK4K_RAMADDR
    mv sp, t1

    la t1, FIXED_JUMPADDR
    jr t1
    nop 

#riscv64-unknown-elf-objdump -D set_stack.o 
#set_stack.o:     file format elf32-littleriscv

#Disassembly of section .text:

#00000000 <app_entry>:
#   0:   00000013                nop
#   4:   80001337                lui     t1,0x80001
#   8:   00030113                mv      sp,t1
#   c:   20000337                lui     t1,0x20000
#  10:   10030313                addi    t1,t1,256 # 20000100 <FIXED_JUMPADDR>
#  14:   00030067                jr      t1
#  18:   00000013                nop

# hexdump -C setstack.bin 
# 00000000  13 00 00 00 37 13 00 80  13 01 03 00 37 03 00 20  |....7.......7.. |
# 00000010  13 03 03 10 67 00 03 00  13 00 00 00              |....g.......|
# 0000001c