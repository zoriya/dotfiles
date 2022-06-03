#!/bin/sh

MEM=$(free | grep Mem | awk '{printf("%d", $3/$2 * 100.0)}')

echo "^C10^ ^d^ $MEM%"

case $BUTTON in
	1) kitty --class htop htop;;
esac

