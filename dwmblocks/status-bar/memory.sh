#!/bin/sh

MEM=$(free | grep Mem | awk '{printf("%d", $3/$2 * 100.0)}')

echo "^c#a3be8c^ ^d^ $MEM%"

case $BLOCK_BUTTON in
          1) setsid -f st -c htop -n htop -e htop;;
esac

