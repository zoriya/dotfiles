#!/bin/sh

case $BUTTON in
	1) fcitx5-remote -t;;
esac

echo -n "^C6^ ^d^"

if [[ $(fcitx5-remote) = "2" ]]; then
	echo "jp"
else
	echo "en"
fi
