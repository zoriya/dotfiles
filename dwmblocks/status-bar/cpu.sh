#!/bin/sh

echo -n "^c#ebcb8b^ ^d^ $(grep -o "^[^ ]*" /proc/loadavg)"

case $BLOCK_BUTTON in
	1) setsid -f st -c htop -n htop -e htop;;
esac
