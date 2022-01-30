#!/usr/bin/env zsh

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR="$monitor" polybar -c "$XDG_CONFIG_HOME"/polybar/config.ini main &
done
