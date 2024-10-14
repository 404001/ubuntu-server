
# Installation Guide: Console User Interface with tmux on Ubuntu Server

This guide will show you how to create a minimalist user interface for your Ubuntu server using **tmux**. It includes a status bar in the console displaying useful information such as the IP address, date, and time.

## 1. Install tmux

First, you need to install **tmux** on your server if it's not already installed.

```bash
sudo apt update
sudo apt install tmux
```

## 2. Configure the tmux status bar

After installing **tmux**, you need to create or edit the `.tmux.conf` configuration file to customize the status bar.

Open or create the configuration file:

```bash
nano ~/.tmux.conf
```

Then, add the following configuration to customize the status bar. This configuration will display the server's IP address, date, time, and the current user.

```bash
# Status bar configuration
set -g status on
set -g status-interval 5   # Update the status bar every 5 seconds
set -g status-justify left
set -g status-bg black     # Black background
set -g status-fg white     # White text

# Left status bar (User and session)
set -g status-left-length 40
set -g status-left "#[bg=blue,fg=white] #(whoami) #[default] | #[fg=yellow]Session: #S"

# Right status bar (Date, Time, IP)
set -g status-right-length 100
set -g status-right "#[fg=green] #(hostname -I | cut -d' ' -f1) #[fg=cyan] %Y-%m-%d %H:%M:%S"

# Colors for the active window
setw -g window-status-current-bg blue
setw -g window-status-current-fg white

# Colors for inactive windows
setw -g window-status-bg black
setw -g window-status-fg green
```

## 3. Reload the tmux configuration

To apply the changes, either start a new **tmux** session or reload the configuration in an existing session with the following command:

```bash
tmux source-file ~/.tmux.conf
```

## 4. Automatically start tmux on login

If you want **tmux** to start automatically every time you log into the server, add the following to your **~/.bashrc** file:

```bash
# Automatically start tmux if not already inside a tmux session
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach || tmux new-session
fi
```

This will ensure that **tmux** runs automatically when you log in, loading the customized status bar.

## 5. Additional options

You can further customize the status bar by adding more information, such as CPU or memory usage.

### Example to display CPU usage:

```bash
set -g status-right "#[fg=green] #(hostname -I | cut -d' ' -f1) #[fg=cyan] %Y-%m-%d %H:%M:%S #[fg=yellow]CPU: #(top -bn1 | grep 'Cpu(s)' | awk '{print $2}')%"
```

## 6. Conclusion

With this setup, you have configured a minimalist and efficient user interface that allows you to monitor useful information directly from the console on your **Ubuntu Server**.
