        section .text
        global _start
_start:
        mov dword [rsp-4], `rld\n`
                    ; Use back ticks instead of single quotes
                    ; To parse the string like C. We can write safely
                    ; in the 128 bytes below RSP because of the
                    ; Linux red zone.
        mov dword [rsp-8], 'o Wo'
        mov dword [rsp-12],'Hell'
        ; Per un elenco delle systemcall con gli argomenti nei registri: https://syscalls.w3challs.com/?arch=x86_64
        mov rax,0x1         ; Identificativo della system call write
        mov rdi,0x1         ; Lo standard output di solito e` sul file descriptor 1
        lea rsi,[rsp-12]    ; Indirizzo della sequenza di caratteri da essere scritta sul fd 1
        mov rdx,12          ; Lunghezza della sequenza di caratteri
        syscall
        ; Inizio della fine
        mov rax,0x3c      ; Identificativo della system call exit
        xor rdi,rdi       ; exit-status
        syscall
