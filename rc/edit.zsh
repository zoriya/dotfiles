rc()
{
	if [[ -z "$1" ]]; then
		cd $DOTFILES
	elif [[ -d "$DOTFILES/$1" ]]; then
		echo "Only files c&an be edited via rc."
		return 1
	else
		edit $DOTFILES/$1
	fi
}

_rc()
{
	[[ ${#words[@]} -le 2 ]] && _files -W $DOTFILES
}
#compdef _rc rc
compdef _rc rc
