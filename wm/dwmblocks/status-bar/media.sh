#!/bin/bash

case $(playerctl status) in
Playing) echo -n "^c#a48ead^ ^d^" ;;
Paused)  echo -n "^c#a48ead^ ^d^" ;;
*)       exit 1 ;;
esac

echo -n "$(playerctl metadata title) - $(playerctl metadata artist)"