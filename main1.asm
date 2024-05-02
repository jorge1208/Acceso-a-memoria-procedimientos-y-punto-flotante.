pot:
    # Guardar registros que se utilizarán
    addi $sp, $sp, -8      # Reservar espacio en la pila
    sw $ra, 4($sp)         # Guardar $ra (return address)
    sw $s0, 0($sp)         # Guardar $s0 (posiblemente otros registros si se utilizan)

    # Argumentos: $a0 (base), $a1 (exponente)
    move $s0, $a0          # $s0 = base
    move $t1, $a1          # $t1 = exponente
    li $v0, 1              # Inicializar resultado como 1

    # Caso especial: exponente = 0
    beq $t1, $zero, end    # Si exponente es 0, retorna 1

    # Cálculo de la potencia
loop:
    mult $v0, $s0          # $v0 = $v0 * base
    mflo $v0               # $v0 = resultado de la multiplicación
    addi $t1, $t1, -1      # Decrementar exponente
    bne $t1, $zero, loop   # Repetir hasta que exponente sea 0

end:
    lw $ra, 4($sp)         # Restaurar $ra
    lw $s0, 0($sp)         # Restaurar $s0 (otros registros si es necesario)
    addi $sp, $sp, 8       # Liberar espacio en la pila
    jr $ra                 # Retornar al llamador
main:
    # Llamada a pot con base = 2, exponente = 3
    li $a0, 2              # Base
    li $a1, 3              # Exponente
    jal pot                # Llamar a la función pot

