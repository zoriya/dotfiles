#!/usr/bin/env zsh

TODO_FILE=~/todo

touch $TODO_FILE

if [[ ! -z $* ]]; then
	if [[ $* == +* ]]; then
		LINE=$(echo $* | sed 's/^+\s*//g')
		echo -e "$(date +"%B %d %H:%M"): $LINE" >> $TODO_FILE
	else
		sed -i -r "/^$*$/d" $TODO_FILE
	fi
fi

cat $TODO_FILE