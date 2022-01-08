#!/usr/bin/env zsh

cd $(dirname $0)

cancel="\u202Dﰸ"
shutdown="襤"
reboot=""
lock=""
logout=""

opt=($cancel $shutdown $reboot $lock $logout)

case $(print -l "${(@)opt}" | rofi -theme ./powermenu.rasi -dmenu) in
$cancel)   ;;
$shutdown) systemctl poweroff ;;
$reboot)   systemctl reboot ;;
$lock)     source $DOTFILES/i3lock/lock.zsh && lock ;;
$logout)   ;;
esac
