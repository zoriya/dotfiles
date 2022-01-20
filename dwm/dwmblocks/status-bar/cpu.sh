#!/bin/sh

echo -n "^c#ebcb8b^ ^d^ $(grep -o "^[^ ]*" /proc/loadavg)"

case $BUTTON in
	1) kitty --class htop htop;;
esac
