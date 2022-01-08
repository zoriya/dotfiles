#!/usr/bin/env zsh

case $BUTTON in
	1) kitty --class pamix pamix ;; 
	4) pulseaudio-ctl up ;;
	5) pulseaudio-ctl down ;;
esac

STATUS=$(pulseaudio-ctl full-status 2> /dev/null)
if [[ $? != 0 ]]; then
	echo "^c#abe8c^婢 ^d^ ??%"
	exit 0
fi
PERCENT=$(echo $STATUS | cut -d' ' -f 1)

if [[ $(echo $STATUS | cut -d' ' -f 2) == "yes" ]]; then
	echo "^c#a3be8c^婢 ^d^ $PERCENT%"
else
	echo "^c#a3be8c^墳 ^d^ $PERCENT%"
fi
