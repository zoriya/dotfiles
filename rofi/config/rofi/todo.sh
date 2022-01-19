#!/usr/bin/env zsh

# Display a todo menu, press enter to mark an item as done and use +todo to add one item.
# The todo file can be specified using the TODO_FILE envvar (defaults to ~/todo)
# The todo file can be automatically synced via git if the TODO_GIT envvar point to a bare git repository.
# Custom values must be exported in the ~/.profile for them to be picked by rofi

[[ -f ~/.config/zsh/localrc ]] && source ~/.config/zsh/localrc
[[ -z $TODO_FILE ]] && TODO_FILE=~/todo
[[ -z $TODO_GIT  ]] && TODO_GIT=$(realpath $DOTFILES/../.todo)

[[ -e $TODO_FILE ]] || touch $TODO_FILE

if [[ ! -z $* ]]; then
	if [[ $* == +* ]]; then
		LINE=$(echo $* | sed 's/^+\s*//g')
		echo -e "$(date +"%B %d %H:%M"): $LINE" >> $TODO_FILE
		if [[ ! -z $TODO_GIT ]]; then
			todogit add $TODO_FILE > /dev/null 2>&1
			todogit commit -m "Adding the task \"$LINE\"" > /dev/null 2>&1
		fi
	else
		sed -i -r "/^$*$/d" $TODO_FILE
		if [[ ! -z $TODO_GIT ]]; then
			todogit add $TODO_FILE > /dev/null 2>&1
			todogit commit -m "Marking \"$*\" as done" > /dev/null 2>&1
		fi
	fi
fi

cat $TODO_FILE
if [[ ! -z $TODO_GIT ]]; then
	coproc { todogit pull; todogit push; }
fi

