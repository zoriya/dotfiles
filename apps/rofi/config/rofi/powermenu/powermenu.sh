#!/usr/bin/env zsh

cd $(dirname $0)

cancel="\u202Dﰸ"
shutdown="襤"
reboot=""
lock=""
suspend="鈴"
logout=""

opt=($lock $suspend $logout $reboot $shutdown)

case $(print -l "${(@)opt}" | dmenu -theme ./powermenu.rasi) in
$cancel)   ;;
$shutdown) systemctl poweroff ;;
$reboot)   systemctl reboot ;;
$lock)     lock ;; 
$suspend)  systemctl suspend ;;
$logout)   ;;
esac
