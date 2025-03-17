#!/bin/bash

# Verifica que se haya pasado un parámetro
if [ $# -ne 1 ]; then
    echo "grupo_miembros muestra los miembros de un grupo y usuario_grupo muestra los grupos de un usuario"
    echo "escribe textual el comando para acceder al menu del script"
    echo "Uso: $0 <grupo_miembros|usuario_grupo>"
    exit 1
fi

# Función para listar miembros de un grupo
listar_miembros_grupo() {
    read -p "Introduce el nombre del grupo: " grupo
    if grep -q "^$grupo:" /etc/group; then
        echo "Miembros del grupo '$grupo':"
        grep "^$grupo:" /etc/group | cut -d: -f4 | tr ',' '\n'
    else
        echo "El grupo '$grupo' no existe."
    fi
}

# Función para listar grupos de un usuario
listar_grupos_usuario() {
    read -p "Introduce el nombre del usuario: " usuario
    if id "$usuario" &>/dev/null; then
        echo "Grupos a los que pertenece el usuario '$usuario':"
        groups "$usuario"
    else
        echo "El usuario '$usuario' no existe."
    fi
}

# Ejecuta la función correspondiente según el parámetro
case "$1" in
    grupo_miembros)
        listar_miembros_grupo
        ;;
    usuario_grupo)
        listar_grupos_usuario
        ;;
    *)
        echo "Parámetro no válido. Usa 'grupo_miembros' o 'usuario_grupo'."
        exit 1
        ;;
esac
