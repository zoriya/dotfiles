#!/usr/bin/env zsh

trap 'kill $(jobs -p) 2>/dev/null' SIGTERM EXIT

export MONITOR=$(xrandr --listactivemonitors | awk '{print $4}' | sed "$(($1 + 2))q;d")
display=$(echo "$DISPLAY" | tr -d ':')
export STDINFIFO="/tmp/polybar-${display}.${MONITOR}-stdin.fifo"

polybar -c "$XDG_CONFIG_HOME"/polybar/config.ini main &
# while ! pgrep -axf "cat ${fifo}"; do : ; done
# todo ask xmonad to send a refresh to update polybar

cat > "$STDINFIFO"

