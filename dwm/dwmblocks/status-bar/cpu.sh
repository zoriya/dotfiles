#!/bin/sh

echo -n "^C3^ ^d^ $(grep -o "^[^ ]*" /proc/loadavg)"

case $BUTTON in
	1) kitty --class htop htop;;
esac
