# Opcode
This repo is called "Opcode" beacuse you can use it to get the opcodes of instructions inside a .text section of an ELF file following these steps:
1) Compile a NASM program:
>nasm -f elf64 iniezione.asm -o iniezione.o
2) Link the .o file with:
>ld iniezione.o -o iniezione
3) Extract the binary form of the .text program via:
>objcopy -O binary -j .text iniezione iniezione.bin
4) Run the .py program:
>python3 binToOpcode.py iniezione.bin
