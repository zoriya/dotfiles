#! /bin/sh

icon=
# events=$(calcurse -a | grep -- '->' | wc -l)
# if [ ! "$events" = "0" ]; then
#   events="($events) "
# else
#   events=""
# fi

cmd=$(date +"%h %e")

echo -n "^c#0f111a^^b#88c0d0^ $icon $events$cmd ^d^"

case $BLOCK_BUTTON in
    1) setsid -f st -c center -n center -e calcurse;;
esac

# next=$(calcurse -n | tail -1)

# if [ ! "$next" = "" ]; then
#   name=$(echo "$next" |  cut -d ' ' -f 5- -)
#   time_left=$(date --date="$(echo "$next" |  cut -d '[' -f2 | cut -d ']' -f1 )" "+%k%M")

#   if [ "$time_left" -lt 7 ]; then
#     if [ ! -f "$XDG_CACHE_HOME/calcurse" ];then
#       touch "$XDG_CACHE_HOME/calcurse"
#     fi

#     if [ "$(grep "$name" "$XDG_CACHE_HOME/calcurse")" = "" ]; then
#       time=$(calcurse -a | grep -E "\s*$name\$" -B 1 | head -n 1 | cut -c4-8)
#       echo "$name" > "$XDG_CACHE_HOME/calcurse"
#       canberra-gtk-play -i bell -V 20
#       dunstify -a "  Event approaching" "[$time] $name"
#     fi
#   fi
# fi