        section .text
        global _start
_start:
;        mov rax,0x39                ; Identificativo fork
;        syscall
;        
;        cmp rax,0x0
;        jz figlio
;        ; Padre
;        xor rax,rax
;        ret
;        
;figlio:
        mov rax,0x3B                ; Identificativo della execve
        
        xor rdx,rdx                 ; NULL ad envp
        
        push 0                    ; NULL per indicare la fine di argv
        mov rsi,`ZZZZZZZ\0`
        push rsi
        push rsp
        mov rsi,rsp                 ; Puntatore all'inizio della stringa argv
        
        mov rdi,`//touch\0`
        push rdi
        mov rdi,"/bin////"
        push rdi
        mov rdi,rsp                 ; Puntatore all'inizio della stringa indicante il progamma da eseguire
        
        syscall
        
        mov rax,0x3C                ; Identificativo della exit
        xor rdi,rdi                 ; exit-status=0
        syscall
