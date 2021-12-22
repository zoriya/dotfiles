#!/bin/sh

case $BUTTON in
	1) setsid -f st -c pamix -n pamix -e pamix ;;
	4) pulseaudio-ctl up ;;
	5) pulseaudio-ctl down ;;
esac

STATUS=$(pulseaudio-ctl full-status)
PERCENT=$(echo $STATUS | cut -d' ' -f 1)

if [ $(echo $STATUS | cut -d' ' -f 2) == "yes" ]; then
	echo "^c#a3be8c^婢 ^d^ $PERCENT%"
else
	echo "^c#a3be8c^墳 ^d^ $PERCENT%"
fi