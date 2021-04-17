        section .text
        global _start
_start:
        mov rsi,`AAAAAAA\0`
        push rsi ; "ABC\0"
        mov rsi, rsp     ; &"ABC\0"
        mov rdi,`/bin/sh\0`
        push rdi ; "/sh\0"
        mov rdi, rsp     ; &"//bin/sh\0"
        push 0
        push rsi         ; &"ABC\0"
        push rdi         ; &"//bin/sh\0"
        mov rsi, rsp     ; args["//bin/sh\0", "ABC\0"]
        mov rdx, 0x0    ; envp[NULL]
        mov rax,0x3B
        syscall
        
        mov rax,0x3C                ; Identificativo della exit
        xor rdi,rdi                 ; exit-status=0
        syscall
