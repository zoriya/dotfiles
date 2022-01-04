#!/usr/bin/env zsh

TODO_FILE=~/todo

add_todo()
{
	echo -e "$(date +"%B %d %H:%M") $*" >> $TODO_FILE
}

remove_todo()
{
	sed -i "/^$*$/d" $TODO_FILE
}

if [[ ! -z "$@" ]; then
	if [[ $@ == +* ]]; then
		LINE=$(echo $@ | sed s/^+//g)
		add_todo $LINE
	else
		MATCHING=$(grep -n "^$*$" $TODO_FILE)
		if [[ -n "$MATCHING" ]]; then
			remove_todo $MATCHING
		fi
	fi
fi

cat $TODO_FILE