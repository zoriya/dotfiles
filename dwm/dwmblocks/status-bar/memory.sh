#!/bin/sh

MEM=$(free | grep Mem | awk '{printf("%d", $3/$2 * 100.0)}')

echo "^c#a3be8c^ ^d^ $MEM%"

case $BUTTON in
	1) kitty --class htop htop;;
esac

