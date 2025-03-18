#!/bin/bash

# Función para crear múltiples usuarios
crear_usuarios() {
    for usuario in "$@"; do
        if id "$usuario" &>/dev/null; then
            echo "El usuario '$usuario' ya existe."
        else
            sudo useradd -m "$usuario"
            echo "Usuario '$usuario' creado correctamente."

            # Preguntar si se desea asignar un grupo primario
            read -p "¿Deseas asignar un grupo primario a '$usuario'? (s/n): " asignar_grupo_primario
            if [[ "$asignar_grupo_primario" == "s" || "$asignar_grupo_primario" == "S" ]]; then
                read -p "Introduce el nombre del grupo primario: " grupo_primario
                if grep -q "^$grupo_primario:" /etc/group; then
                    sudo usermod -g "$grupo_primario" "$usuario"
                    echo "Grupo primario '$grupo_primario' asignado a '$usuario'."
                else
                    echo "El grupo '$grupo_primario' no existe."
                fi
            fi

            # Preguntar si se desea asignar un grupo secundario
            read -p "¿Deseas asignar un grupo secundario a '$usuario'? (s/n): " asignar_grupo_secundario
            if [[ "$asignar_grupo_secundario" == "s" || "$asignar_grupo_secundario" == "S" ]]; then
                read -p "Introduce el nombre del grupo secundario: " grupo_secundario
                if grep -q "^$grupo_secundario:" /etc/group; then
                    sudo usermod -aG "$grupo_secundario" "$usuario"
                    echo "Grupo secundario '$grupo_secundario' asignado a '$usuario'."
                else
                    echo "El grupo '$grupo_secundario' no existe."
                fi
            fi
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
