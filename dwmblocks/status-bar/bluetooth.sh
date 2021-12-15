#!/bin/sh

power=$(timeout 1 bluetoothctl show | grep "Powered: yes" | wc -w)

if [ "$power" -eq 0 ]; then
	:
else
	device="$(echo info | timeout 1 bluetoothctl | grep 'Name')"

	if [ ! "$device" = "" ]; then
		echo "^c#81a1c1^^d^ $(echo "$device" | head -n 1 | xargs | cut -c 7-)"
	else
		echo "^c#81a1c1^^d^"
	fi

fi

case $BUTTON in
	1) blueberry ;;
esac
