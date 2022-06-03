#!/bin/sh

case $BUTTON in
	1) dunstctl set-paused $([[ $(dunstctl is-paused) == "true" ]] && echo "false" || echo "true") ;;
esac

if [ $(dunstctl is-paused) = "true" ]; then
	echo "^C6^ ^d^"
else
	echo "^C6^ ^d^"
fi
