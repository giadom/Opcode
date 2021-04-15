        section .text
        global _start
_start:
        ; 64 bit systems that use System V AMD64 ABI (including Linux and macOS) use the red zone
        mov byte [rsp-1],0xA        ; \n
        mov dword [rsp-5], 'rld!'
        mov dword [rsp-9], 'o Wo'
        mov dword [rsp-13],'Hell'
        ; Per un elenco delle systemcall con gli argomenti nei registri: https://syscalls.w3challs.com/?arch=x86_64
        mov rax,0x1                 ; Identificativo della system call write
        mov rdi,0x1                 ; Lo standard output di solito e` sul file descriptor 1
        mov rsi,rsp                 ; Indirizzo della sequenza di caratteri da essere scritta sul fd 1
        sub rsi,13
        mov rdx,13                  ; Lunghezza della sequenza di caratteri
        syscall
        ; Ritorno alla funzione chiamante (qualora ce ne fosse una)
        xor rax,rax                 ; Ritorno zero
        ret
        ; Termino l'esecuzione (qualora non esistessa una funzione chiamante)
        ;mov rax,0x3c                ; Identificativo della system call exit
        ;xor rdi,rdi                 ; exit-status
        ;syscall
