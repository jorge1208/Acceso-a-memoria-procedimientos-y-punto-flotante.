
booth_mult:
    addi $sp, $sp, -4   # Reservar espacio en la pila
    sw $ra, 0($sp)      # Guardar $ra (return address)

    # Argumentos: $a0 (M), $a1 (Q)
    move $t0, $a0       # $t0 = M (multiplicando)
    move $t1, $a1       # $t1 = Q (multiplicador)
    li $v0, 0           # Inicializar $v0 como parte baja del producto (32 bits)
    li $v1, 0           # Inicializar $v1 como parte alta del producto (32 bits)

    li $t2, 32          # Contador para el número de bits (32 bits)
    li $t3, 0           # Inicializar $t3 como 0 para el seguimiento del último bit de Q

booth_loop:
    andi $t4, $t1, 0x3  # $t4 = Q AND 0b11 (Obtener últimos dos bits de Q)

    beq $t4, $zero, booth_shift  # Si Q[1:0] == 0, solo corrimiento aritmético
    beq $t4, 0x1, booth_add       # Si Q[1:0] == 01, restar M y corrimiento
    beq $t4, 0x2, booth_sub       # Si Q[1:0] == 10, sumar M y corrimiento
    beq $t4, 0x3, booth_shift      # Si Q[1:0] == 11, solo corrimiento aritmético

booth_shift:
    sra $t0, $t0, 1     # Corrimiento aritmético de M hacia la derecha (aritmético)
    sra $t1, $t1, 1     # Corrimiento aritmético de Q hacia la derecha (aritmético)
    subi $t2, $t2, 1    # Decrementar contador de bits
    bnez $t2, booth_loop # Repetir si quedan bits por procesar
    j booth_done         # Saltar al final del algoritmo cuando se termina

booth_add:
    addu $v0, $v0, $t0  # Sumar M al producto (parte baja)
    sra $v1, $v0, 31    # Extender el bit más significativo de $v0 a $v1
    b booth_shift        # Saltar al corrimiento aritmético

booth_sub:
    subu $v0, $v0, $t0  # Restar M al producto (parte baja)
    sra $v1, $v0, 31    # Extender el bit más significativo de $v0 a $v1
    b booth_shift        # Saltar al corrimiento aritmético

booth_done:
    lw $ra, 0($sp)      # Restaurar $ra
    addi $sp, $sp, 4    # Liberar espacio en la pila
    jr $ra              # Retornar al llamador

main:
    li $a0, 10      # M = 10
    li $a1, 5       # Q = 5
    jal booth_mult  # Llamar al procedimiento booth_mult
    li $v0, 10      # Código de salida del programa
    syscall         # Salir del programa

