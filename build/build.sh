
#!/bin/bash

#/****************************************************************************
# *
# *   Copyright (C) 2022 bsvtgc@gmail.com. All rights reserved.
# *   Author: Vincent <bsvtgc@gmail.com>
# *
# ****************************************************************************/

#printf "This build script is work-in-progress\n"

cdir=$(pwd)
#printf "current dir is $cdir"

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
APP=$2
MEM=$3

if [ -z "$3" ]; then
MEM=ram
fi

set_asembler ()
{
# GAS (GNU Assembler)
    GNU_AS=riscv64-unknown-elf-as
    GNU_AS_FLAGS="-march=rv32imac -mno-arch-attr -I ../rv-spec/ -I ../boards/${BOARD}/src"
    GNU_AS_OUTPUT_EXT=.o 
}

set_linker ()
{
# GNU Linker
    GNU_LD=riscv64-unknown-elf-ld
    GNU_LD_SCRIPT=$BOARD-$MEM.lscript
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
    printf "\n## Build settings BOARD=${BOARD}, APP=${APP} ##\n\n"

    BOARD_DIR=../boards/${BOARD}
    BOARD_SRC_DIR=${BOARD_DIR}/src
    cd ${BOARD_SRC_DIR}
    BOARD_FILES=$(ls -p | grep -v / )
    cd ${cdir}

    APP_DIR=../apps/${APP}
    APP_FILES=$(ls ${APP_DIR})

# Executable 
    EXECUTABLE=FINAL_LOAD.elf

    for file in ${BOARD_FILES[@]}; do
        file_trimmed=$( echo "$file" | cut -f 1 -d '.')
        $GNU_AS  ${GNU_AS_FLAGS} ${BOARD_SRC_DIR}/${file} -o ${file_trimmed}.o
    done

     for file in ${APP_FILES[@]}; do
        file_trimmed=$( echo "$file" | cut -f 1 -d '.')
        $GNU_AS  ${GNU_AS_FLAGS} ${APP_DIR}/${file} -o ${file_trimmed}.o
    done

    OBJ_FILES=$( ls *.o )
    #printf "Object files $OBJ_FILES\n"
    $GNU_LD -T../tools/$GNU_LD_SCRIPT  $GNU_LD_FLAGS $OBJ_FILES -o $EXECUTABLE

    printf "Build successful \n\n"
}

set_asembler;
set_linker;
build_executable;
