# Makefile to drive cew testing of asm code using gdb
# P Walsh Feb 2001

# Targets
#   interactive --- assemble program under test and load into gdb
#   bats --- make batch tester from bats.script
#   clean
#   submit -- submit assignment code

# directory where scripts are located and temp files
SD=CewDir

# code beautifier 
INDENT=cat

# version of awk
AWK=awk 

# extra debugger flags
XDBF=-batch -x

# tools 
AS=m68hc11-as
CC=m68hc11-gcc
LD=m68hc11-ld
GDB=m68hc11-gdb
OC=m68hc11-objcopy

default: main.elf

interactive: main.elf
	$(GDB) main.elf

buff.o: buff.s buff.h
	$(AS) -a=buff.lst --gstabs -o buff.o buff.s

clean:
	rm -f *.o *.elf *.gdb *.lst $(SD)/tmp/*

clean_main.s:
	rm -f main.s *.o *.elf *.gdb *.lst $(SD)/tmp/*

main.s: main.c
	$(CC) -S -Os -fomit-frame-pointer -mshort main.c

main.o: main.s
	$(AS) -a=main.lst --gstabs -o main.o main.s soft.s

main.elf: main.o buff.o
	$(LD) -O0 --verbose -N -mshort -mm68hc11elfb main.o buff.o -o main.elf
	$(OC) -O srec --only-section=.text --only-section=.data main.elf main.s19
