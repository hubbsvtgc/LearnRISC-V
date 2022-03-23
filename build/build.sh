
#!/bin/bash

#/****************************************************************************
# *
# *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
# *   Author: Vincent <bsvtgc@gmail.com>
# *
# ****************************************************************************/

printf "This build script is work-in-progress\n"

if [ -z "$1" ]; then
    printf "Provide build option\n"
    printf "./build <option>\n"
    printf "Option list: <board_name> | clean\n"
    exit 1
fi

if [[ "cleanse" == "$1" ]]; then
    rm *.elf
    exit 1
fi

BOARD=$1

build_executable ()
{
    printf "Build for BOARD=$1"
    printf "Right now this just builds the start.S\n"

    SRC_FILES=../boards/hifive1-revb/start.S

# GAS (GNU Assembler)
    GNU_AS=riscv64-unknown-elf-as
    GNU_AS_FLAGS="-march=rv32imac -mno-arch-attr" 
    GNU_AS_OUTPUT_EXT=.o 

# GNU Linker
    GNU_LD=riscv64-unknown-elf-ld
    GNU_LD_SCRIPT=$BOARD.lscript
    GNU_LD_FLAGS=-belf32-littleriscv

# Executable 
    EXECUTABLE=FINAL_LOAD.elf

    $GNU_AS  $GNU_AS_FLAGS $SRC_FILES -o $SRC_FILES.$GNU_AS_OUTPUT_EXT
    $GNU_LD -T../tools/$GNU_LD_SCRIPT  $GNU_LD_FLAGS $SRC_FILES.$GNU_AS_OUTPUT_EXT -o $EXECUTABLE
}

build_executable;
