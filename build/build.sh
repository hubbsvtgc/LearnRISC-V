
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
    rm *.o
    exit 1
fi

BOARD=$1

set_asembler ()
{
# GAS (GNU Assembler)
    GNU_AS=riscv64-unknown-elf-as
    GNU_AS_FLAGS="-march=rv32imac -mno-arch-attr" 
    GNU_AS_OUTPUT_EXT=.o 
}

set_linker ()
{
# GNU Linker
    GNU_LD=riscv64-unknown-elf-ld
    GNU_LD_SCRIPT=$BOARD.lscript
    GNU_LD_FLAGS=-belf32-littleriscv
}

set_compiler ()
{
# GNU Compiler
    GNU_CC=riscv64-unknown-elf-cc
#    GNU_CC_FLAGS=
}

build_executable ()
{
    printf "Build for BOARD=${BOARD}\n"
    printf "Right now this just builds the basic *.S files \n"

    BOARD_DIR=../boards/hifive1-revb
    SRC_FILES=$(ls ${BOARD_DIR})

# Executable 
    EXECUTABLE=FINAL_LOAD.elf

    for file in ${SRC_FILES[@]}; do
        file_trimmed=$( echo "$file" | cut -f 1 -d '.')
        $GNU_AS  ${GNU_AS_FLAGS} ${BOARD_DIR}/${file} -o ${file_trimmed}.o
    done

    OBJ_FILES=$( ls *.o )
    #printf "Object files $OBJ_FILES\n"
    $GNU_LD -T../tools/$GNU_LD_SCRIPT  $GNU_LD_FLAGS $OBJ_FILES -o $EXECUTABLE
}

set_asembler;
set_linker;
build_executable;
