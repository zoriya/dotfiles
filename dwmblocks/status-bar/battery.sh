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
	export bat=$(cat /sys/class/power_supply/BAT*/capacity)
	export status=$(cat /sys/class/power_supply/BAT*/status)
	export plugged=$(cat /sys/class/power_supply/A*/online)

	if [[ $plugged == "1" ]]; then
		echo -n "^c#ebcb8b^$ac_bat^d^"
	elif [[ $bat -lt 10 ]]; then
		echo -n "^c#ebcb8b^$ramp10^d^"
	elif [[ $bat -lt 20 ]]; then
		echo -n "^c#ebcb8b^$ramp20^d^"
	elif [[ $bat -lt "30" ]]; then
		echo -n "^c#ebcb8b^$ramp30^d^"
	elif [[ $bat -lt "40" ]]; then
		echo -n "^c#ebcb8b^$ramp40^d^"
	elif [[ $bat -lt "50" ]]; then
		echo -n "^c#ebcb8b^$ramp50^d^"
	elif [[ $bat -lt "60" ]]; then
		echo -n "^c#ebcb8b^$ramp60^d^"
	elif [[ $bat -lt "70" ]]; then
		echo -n "^c#ebcb8b^$ramp70^d^"
	elif [[ $bat -lt "80" ]]; then
		echo -n "^c#ebcb8b^$ramp80^d^"
	elif [[ $bat -lt "90" ]]; then
		echo -n "^c#ebcb8b^$ramp90^d^"
	elif [[ $bat -le "100" ]]; then
		echo -n "^c#ebcb8b^$ramp100^d^"
	fi
	echo " $bat%"
fi
