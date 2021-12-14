#!/bin/bash

pid=$(pidof redshift)

case $BUTTON in
  1)
    redshift -x
    if [ ! "$pid" = "" ]; then
      kill -9 $pid
      redshift -x
      pid=""
    else
      redshift -r -l "$LATLONG" > /dev/null 2> /dev/null &
      pid="1"
    fi;;
esac

if [ "$pid" = "" ]; then
  echo "^c#ebcb8b^^d^"
else
  echo "^c#ebcb8b^^d^"
fi
