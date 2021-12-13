#!/bin/bash

ramp10=
ramp20=
ramp30=
ramp40=
ramp50=
ramp60=
ramp70=
ramp80=
ramp90=
ramp100=
ac_bat=
ac=ﮣ

if [[ ! $(acpi 2>&1 | grep "No support") ]]; then
	export bat=$(cat /sys/class/power_supply/BAT0/capacity)
	export status=$(cat /sys/class/power_supply/BAT0/status)
	export plugged=$(cat /sys/class/power_supply/AC/online)

	tleft=$(acpi -b | sed -r 's/.* ([0-9]{2}:[0-9]{2}).*/\1/g')
	if [ ! $(echo "$tleft" | grep "Full")]; then
		stats="$tleft"
	else
		stats="$bat%"
	fi
	if [[ $plugged == "1" ]]; then
		echo "^c#ebcb8b^$ac_bat^d^ $stats"
	elif [[ $bat -lt 10 ]]; then
		echo "^c#ebcb8b^$ramp10^d^ $stats"
	elif [[ $bat -lt 20 ]]; then
		echo "^c#ebcb8b^$ramp20^d^ $stats"
	elif [[ $bat -lt "30" ]]; then
		echo "^c#ebcb8b^$ramp30^d^ $stats"
	elif [[ $bat -lt "40" ]]; then
		echo "^c#ebcb8b^$ramp40^d^ $stats"
	elif [[ $bat -lt "50" ]]; then
		echo "^c#ebcb8b^$ramp50^d^ $stats"
	elif [[ $bat -lt "60" ]]; then
		echo "^c#ebcb8b^$ramp60^d^ $stats"
	elif [[ $bat -lt "70" ]]; then
		echo "^c#ebcb8b^$ramp70^d^ $stats"
	elif [[ $bat -lt "80" ]]; then
		echo "^c#ebcb8b^$ramp80^d^ $stats"
	elif [[ $bat -lt "90" ]]; then
		echo "^c#ebcb8b^$ramp90^d^ $stats"
	elif [[ $bat -le "100" ]]; then
		echo "^c#ebcb8b^$ramp100^d^ $stats"
	fi
fi
