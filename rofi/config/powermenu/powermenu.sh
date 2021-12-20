#!/usr/bin/env bash

cd $(dirname $0)

cancel="\u202Dﰸ"
shutdown="襤"
reboot=""
lock=""
logout=""

options="$cancel\n$shutdown\n$reboot\n$lock\n$logout"

case $(echo -e "$options" | rofi -theme ./powermenu.rasi -dmenu) in
$cancel)   ;;
$shutdown) systemctl poweroff ;;
$reboot)   systemctl reboot ;;
$lock)     slock ;;
$logout)   ;;
esac
