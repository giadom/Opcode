        section .text
        global _start
_start:
        ; 64 bit systems that use System V AMD64 ABI (including Linux and macOS) use the red zone
        mov byte [rsp-1],0x0        ; \0
        mov byte [rsp-2],"h"
        mov byte [rsp-3],"s"
        mov dword [rsp-7],"yes."
        
        ; Per un elenco delle systemcall con gli argomenti nei registri: https://syscalls.w3challs.com/?arch=x86_64
        mov rax,0x02                ; Identificativo open
        mov rdi,rsp                 ; Indirizzo di partenza del nome del file
        sub rdi,7
        mov rsi,65                  ; Il valore in flags e` l'or fra O_CREAT e O_WRONLY
        mov rdx,0q0777              ; I permessi imposti sul file creato
        syscall
        
        mov rcx,rax                 ; Mi salvo il file descriptor aperto da open
        
        mov byte [rsp-1],"s"
        mov byte [rsp-2],"e"
        mov byte [rsp-3],"y"
        mov rax,0x01                ; Identificativo write
        mov rdi,rcx                 ; File descriptor in cui scrivere
        mov rsi,rsp                 ; Indirizzo di partenza della stringa da scrivere
        sub rsi,3
        mov rdx,3                   ; Numero di byte da scrivere
        syscall
        
        mov rax,0x03                ; Identificativo close
        mov rdi,rcx                 ; file descriptor da chiudere
        syscall
        
        xor rax,rax
        ret
        ;mov rax,0x3C                ; Identificativo della exit
        ;xor rdi,rdi                 ; exit-status=0
        ;syscall
