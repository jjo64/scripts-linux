#!/bin/bash

# Función para crear múltiples usuarios
crear_usuarios() {
    for usuario in "$@"; do
        if id "$usuario" &>/dev/null; then
            echo "El usuario '$usuario' ya existe."
        else
            sudo useradd -m "$usuario"
            echo "Usuario '$usuario' creado correctamente."
        fi
    done
}

# Función para crear múltiples grupos
crear_grupos() {
    for grupo in "$@"; do
        if grep -q "^$grupo:" /etc/group; then
            echo "El grupo '$grupo' ya existe."
        else
            sudo groupadd "$grupo"
            echo "Grupo '$grupo' creado correctamente."
        fi
    done
}

# Verifica que se haya pasado un comando válido
if [ $# -lt 2 ]; then
    echo "Uso: $0 <usuarios|grupos> <nombre1 nombre2 nombre3 ...>"
    exit 1
fi

# Ejecuta la función correspondiente según el comando
case "$1" in
    usuarios)
        shift  # Elimina el primer argumento (usuarios)
        crear_usuarios "$@"
        ;;
    grupos)
        shift  # Elimina el primer argumento (grupos)
        crear_grupos "$@"
        ;;
    *)
        echo "Comando no válido. Usa 'usuarios' o 'grupos'."
        exit 1
        ;;
esac
