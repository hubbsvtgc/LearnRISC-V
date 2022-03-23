

.section text
.global _main

_main:


loop_forever:
    jal zero, loop_forever;
