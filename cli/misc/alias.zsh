alias "jctl"="sudo journalctl -n 1000 -fu"

if ! type open &> /dev/null; then
	alias "open"="xdg-open"
fi
alias "op"="open"

alias "ssh"="kitty +kitten ssh"

export LESS="-Rj.5"
