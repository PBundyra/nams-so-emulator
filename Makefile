CC=gcc
ASM_BIN=nasm
C_SRC=so_emulator_example
ASM_SRC=so_emulator
NO_CORES=4

all: assemble compile link clean
size: calc_size clean

assemble: $(ASM_SRC).asm
	$(ASM_BIN) -DCORES=$(NO_CORES) -f elf64 -g -F dwarf -w+all -w+error -o $(ASM_SRC).o $(ASM_SRC).asm

compile: $(C_SRC).c
	$(CC) -DCORES=$(NO_CORES) -c -Wall -Wextra -std=c17 -O2 -o $(C_SRC).o $(C_SRC).c

link: assemble compile
	$(CC) -pthread -o $(C_SRC) $(C_SRC).o $(ASM_SRC).o

clean: link
	rm *.o
calc_size $(ASM_SRCmak).asm:
	$(ASM_BIN) -DCORES=4 -f elf64 -w+all -w+error -o $(ASM_SRC).o $(ASM_SRC).asm && size $(ASM_SRC).o
