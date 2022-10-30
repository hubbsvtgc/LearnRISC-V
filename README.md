# Welcome to LearnRISC-V Repository


**Table of Contents:**

1. Directory Structure
1. Supported Boards
    1. Hifive1-RevB
1. Instructions to build

## Directory Structure  
![alt text](https://github.com/hubbsvtgc/LearnRISC-V/blob/release/DirectoryStruct.png?raw=true)


## Instructions to build  

Make sure you have installed the GNU toolchain and OpenOCD from https://www.sifive.com/software. Export the paths so that its visible to the bash script in build directory. Set execution permission to build.sh with `chmod +x` command. 

Issue the command `./build.sh <board> <app> <rom | ram>` to build for a particular `board` and `app` and for flash or ram. <br > 

This repo has multiple braches. 
<br >For hifive1-revb board on release branch, <br > 
`./build.sh hifive1-revb led-blink` builds the app `led-blink` for `hifive1-revb` and
<br >`./build.sh cleanse` to clean. 

## Naming
## General Prefixes
  
.equiv ALL_UPPERCASE_ for constants (memory mapped address, Bitmasks, Constants)  

These constants go in `module.inc` file in `inc` directory. 