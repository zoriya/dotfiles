#!/bin/bash

get_field()
{
	echo "$1" | awk -v field=$2 -F '[\t ]{2,}' '{print $field}'
}

out=$(nmcli device status | grep -v bridge | head -n2 | tail -n1)
type=$(get_field "$out" 2)
status=$(get_field "$out" 3)
ssid=$(get_field "$out" 4) || "no network"

if [ "$type" == "ethernet" ]; then
	icon=$([[ "$status" == "connected" ]] && echo -n " ^d^" || echo -n " ^d^")
elif [ "$type" == "wifi" ]; then
	icon=$([[ "$status" == "connected" ]] && echo -n "直 ^d^" || echo -n "睊 ^d^")
else
	icon=" ^d^"
fi

echo -n $icon$ssid

case $BLOCK_BUTTON in
	1) ~/.local/bin/connman_dmenu ;;
esac
