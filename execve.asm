        section .text
        global _start
_start:
        mov rdx, 0x0            ; NULL ad envp
        mov rsi,`AAAAAAA\0`
        push rsi                ; "AAAAAAA\0"
        mov rsi, rsp            ; Mi prendo &"AAAAAAA\0"
        mov rdi,`//touch\0`
        push rdi                ; "//touch\0"
        mov rdi,"//bin///"
        push rdi                ; "//bin///"
        mov rdi, rsp            ; Mi prendo &"//bin/////touch\0" che sara` il programma da eseguire
        push 0                  ; NULL per indicare la fine di argv
        push rsi                ; Metto l'indirizzo di partenza della stringa AAAAAAA\0
        push rdi                ; Metto l'indirizzo di partenza della stringa //bin/////touch\0"
        mov rsi, rsp            ; argv["//bin////touch\0", "AAAAAAA\0"] il primo argomento di argv deve essere il programma da eseguire
        mov rax,0x3B            ; Identificativo execve
        syscall
        
        mov rax,0x3C                ; Identificativo della exit
        xor rdi,rdi                 ; exit-status=0
        syscall
