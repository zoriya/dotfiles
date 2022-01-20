#!/bin/sh

case $BUTTON in
	1) dunstctl set-paused $([[ $(dunstctl is-paused) == "true" ]] && echo "false" || echo "true") ;;
esac

if [ $(dunstctl is-paused) = "true" ]; then
	echo "^c#88c0d0^ ^d^"
else
	echo "^c#88c0d0^ ^d^"
fi
