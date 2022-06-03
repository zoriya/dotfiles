#!/usr/bin/env zsh

case $BUTTON in
	1) pavucontrol ;;
	4) pulseaudio-ctl up ;;
	5) pulseaudio-ctl down ;;
esac

STATUS=$(pulseaudio-ctl full-status 2> /dev/null)
if [[ $? != 0 ]]; then
	echo "^C5^婢 ^d^ ??%"
	exit 0
fi
PERCENT=$(echo $STATUS | cut -d' ' -f 1)

if [[ $(echo $STATUS | cut -d' ' -f 2) == "yes" ]]; then
	echo "^C5^婢 ^d^ $PERCENT%"
else
	echo "^C5^墳 ^d^ $PERCENT%"
fi
