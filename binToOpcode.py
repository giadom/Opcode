import sys
with open(sys.argv[1],'rb') as input_file:
    byte_stringa= input_file.read()
for byte in byte_stringa:
    print('\\x%02x'%byte,end='') # Il primo % permette di mettere in quella posizione byte (un int); 02 impone di inserire almeno due simboli e di mettere il padding con 0 (in testa); x dice esadecimale in minuscolo
print()
