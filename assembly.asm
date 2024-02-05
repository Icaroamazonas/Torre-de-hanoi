section .data
    prompt db "Digite o número de discos: ", 0
    error_msg db "Por favor, insira um número válido.", 0
    disks db 0

section .text
    global _start

_start:
    ; Exibindo o prompt para o usuário
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 28
    int 0x80  ; syscall para sys_write

    ; Lendo o número de discos inserido pelo usuário
    mov eax, 3
    mov ebx, 0
    mov ecx, disks
    mov edx, 2
    int 0x80  ; syscall para sys_read

    ; Convertendo a entrada para um número
    mov eax, 0
    mov ecx, disks
    sub ecx, '0'
    movzx eax, byte [ecx]

    ; Verificando se o número é válido
    cmp eax, 0
    jl  input_error
    cmp eax, 20  ; Defina o limite para o número de discos conforme necessário
    jg  input_error

    ; Chamando a função de resolução da Torre de Hanoi
    mov ebx, eax  ; Passando o número de discos como argumento
    call hanoi

    ; Terminando o programa
    mov eax, 1
    xor ebx, ebx
    int 0x80  ; syscall para sys_exit

hanoi:
    ; Procedimento recursivo para resolver a Torre de Hanoi
    ; Argumento: ebx - Número de discos
    ; Registros preservados: eax, ecx, edx

    ; Verificando o caso base (sem discos ou apenas um disco)
    cmp ebx, 1
    jbe end_hanoi

    ; Movendo N-1 discos da Torre A para a Torre B usando a Torre C como auxiliar
    push ecx
    push edx
    mov ecx, ebx
    dec ecx
    mov edx, 6  ; Identificador da Torre C
    mov eax, ebx
    sub eax, 1
    push eax
    push edx
    push 1  ; Número de discos a ser movido
    call hanoi
    add esp, 12

    ; Movendo o disco restante da Torre A para a Torre C
    mov eax, 1
    mov ecx, 1  ; Identificador da Torre A
    mov edx, 3  ; Identificador da Torre C
    int 0x80  ; syscall para mover disco

    ; Movendo os N-1 discos da Torre B para a Torre C usando a Torre A como auxiliar
    mov ecx, ebx
    dec ecx
    mov edx, 1  ; Identificador da Torre A
    mov eax, ebx
    sub eax, 1
    push eax
    push edx
    push 2  ; Número de discos a ser movido
    call hanoi
    add esp, 12

end_hanoi:
    pop edx
    pop ecx
    ret

input_error:
    ; Exibindo mensagem de erro e terminando o programa
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, 34
    int 0x80  ; syscall para sys_write

    mov eax, 1
    xor ebx, ebx
    int 0x80  ; syscall para sys_exit
