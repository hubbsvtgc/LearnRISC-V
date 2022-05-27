# Welcome to LearnRISC-V Repository


**Table of Contents:**

1. Directory Structure
1. Supported Boards
    1. Hifive1-RevB
1. Instructions to build

## Directory Structure  
![alt text](https://github.com/hubbsvtgc/LearnRISC-V/blob/trunk/DirectoryStruct.png?raw=true)


## Instructions to build  

Make sure you have installed the GNU toolchain and OpenOCD from https://www.sifive.com/software. Export the paths so that its visible to the bash script in build directory. Set execution permission to build.sh with `chmod +x` command. 

Issue the command `./build.sh <board> <app>` to build for a particular `board` and `app`. <br > 

<br >For hifive1-revb board, <br > 
`./build.sh hifive1-revb gpio21-onoff` builds the app `gpio21-onoff` for `hifive1-revb` and 
<br >`./build.sh cleanse` to clean. 

## Naming
## General Prefixes
FN_ prefix for functions  
LB_ prefix for labels  (address offset)  
VAR_ prefix for variables  (Stack start address)  
K_ prefix for temporary constant (K_SRCID_7)  
  
.equiv ALL_UPPERCASE_ for constants (memory mapped address, Bitmasks, Constants)  

  
## Module Level Prefixes

FN_mod_






