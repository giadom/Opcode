#include <stdio.h>
#include <stdlib.h>
#include <string.h>         // Serve per memcpy
#include <sys/mman.h>       // Serve per mmap

int
main(int argc , char *argv[])
{
    char code[]=\
    "\xc6\x44\x24\xff\x0a\xc7\x44\x24\xfb\x72\x6c\x64\x21\xc7\x44\x24\xf7\x6f\x20"\
    "\x57\x6f\xc7\x44\x24\xf3\x48\x65\x6c\x6c\xb8\x01\x00\x00\x00\xbf\x01\x00\x00"\
    "\x00\x48\x89\xe6\x48\x83\xee\x0d\xba\x0d\x00\x00\x00\x0f\x05\x48\x31\xc0\xc3" ; // hello_world
    /*
    Per dettagli sul funzionamento di mmap vedi da pagina 370 e da pagina 675 di
    "Understanding Linux Kernel" e pagina 434 di "GaPIL".
    */
    void *buf = mmap (0 , sizeof(code) , PROT_READ|PROT_WRITE|PROT_EXEC , MAP_PRIVATE|MAP_ANON , -1 , 0);
    
    memcpy (buf , code , sizeof(code));
    /*
    Bisogna dire al GCC che opera su x86 che la memcpy appena eseguita non e` una "dead store".
    (GCC pensa che quella memcpy sia dead store perche' afferma che dereferenziare un puntatore a funzione non sia
    equivalente a leggere i byte da quell'indirizzo).
    In verita` la seguente funzione non svuota alcuna instruction cache: marca la zona di memoria come "usata" in modo
    da permettere davvero la copiatura.
    */
    __builtin___clear_cache(buf , buf+sizeof(code)-1); // -1 perche' inizio a contare da 0
    int64_t ret = ((int(*)(void))buf)();
    return ret;
}
/*
Perche' non usare malloc + mprotect al posto di mmap:
- i permessi sono impostati solamente sulle pagine di memoria, mentre la memoria
  allocata con malloc molto probabilmente non e` allineata alla pagina e dunque
  bisognerebbe mettere i permessi anche sulle pagine di memoria adiacenti col rischio
  di fare danni visto che non sono zone di memoria di nostra proprieta`.
- prima di usare free bisogna ripristinare i permessi vecchi altrimenti si avrebbero
  guasti interni
*/
