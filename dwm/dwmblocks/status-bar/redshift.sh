#!/bin/bash

pid=$(pidof redshift)

case $BUTTON in
1)
	if [ ! "$pid" = "" ]; then
		kill -9 $pid
		redshift -x > /dev/null 2> /dev/null &
		pid=""
	else
		redshift -l $(curl -s "https://location.services.mozilla.com/v1/geolocate?key=geoclue" | awk 'OFS=":" {print $3,$5}' | tr -d ',}') > /dev/null 2> /dev/null &
		pid="1"
	fi;;
esac

if [ "$pid" = "" ]; then
	echo "^c#ebcb8b^^d^"
else
	echo "^c#ebcb8b^^d^"
fi
