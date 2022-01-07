#!/usr/bin/env zsh

get_field()
{
	echo "$1" | awk -v field=$2 -F '[\t ]{2,}' '{print $field}'
}

out=$(nmcli device status | grep -v bridge | head -n2 | tail -n1)
type=$(get_field "$out" 2)
stat=$(get_field "$out" 3)
ssid=$(get_field "$out" 4) || "no network"

if [[ "$type" == "ethernet" ]]; then
	icon=$([[ "$stat" == "connected" ]] && echo -n " ^d^" || echo -n " ^d^")
elif [[ "$type" == "wifi" ]]; then
	icon=$([[ "$stat" == "connected" ]] && echo -n "直 ^d^" || echo -n "睊 ^d^")
else
	icon=" ^d^"
fi

echo -n $icon$ssid

case $BUTTON in
1) [[ $(pidof nm-applet > /dev/null) -eq 0 ]] && killall nm-applet  || coproc nm-applet --no-agent ;;
esac
