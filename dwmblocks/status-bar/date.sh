#! /bin/sh

icon=
cmd=$(date +"%h %e")
echo -n "^c#0f111a^^b#88c0d0^ $icon $cmd ^d^"

case $BLOCK_BUTTON in
	1) setsid -f st -c center -n center -e calcurse;;
esac