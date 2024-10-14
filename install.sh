#!/bin/bash

echo "Actualizando el sistema..."
sudo apt update -y
sudo apt upgrade -y

if ! command -v tmux &> /dev/null
then
    echo "tmux no está instalado. Instalando tmux..."
    sudo apt install tmux -y
else
    echo "tmux ya está instalado."
fi

TMUX_CONF=~/.tmux.conf
if [ ! -f "$TMUX_CONF" ]; then
    echo "Creando archivo de configuración de tmux en ~/.tmux.conf..."
    cat <<EOL > "$TMUX_CONF"

set -g status on
set -g status-interval 5   # Actualiza la barra cada 5 segundos
set -g status-justify left
set -g status-bg black     # Fondo negro
set -g status-fg white     # Texto blanco

set -g status-left-length 40
set -g status-left "#[bg=blue,fg=white] #(whoami) #[default] | #[fg=yellow]Session: #S"

set -g status-right-length 100
set -g status-right "#[fg=green] #(hostname -I | cut -d' ' -f1) #[fg=cyan] %Y-%m-%d %H:%M:%S"

setw -g window-status-current-bg blue
setw -g window-status-current-fg white

setw -g window-status-bg black
setw -g window-status-fg green
EOL
    echo "Archivo ~/.tmux.conf creado."
else
    echo "El archivo ~/.tmux.conf ya existe. No se modificará."
fi

echo "Verificando permisos del archivo ~/.tmux.conf..."
chmod 644 ~/.tmux.conf
echo "Permisos correctos establecidos."

if [ ! -d "/etc/tmux-0" ]; then
    echo "Creando el directorio /etc/tmux-0/..."
    sudo mkdir -p /etc/tmux-0
    echo "Directorio /etc/tmux-0/ creado."
else
    echo "El directorio /etc/tmux-0/ ya existe."
fi

echo "Recargando la configuración de tmux..."
tmux source-file ~/.tmux.conf
echo "Configuración recargada."

echo "Iniciando tmux para verificar que funciona..."
tmux new -d -s test_session
tmux ls

echo "Todo listo. tmux ha sido instalado y configurado correctamente."
