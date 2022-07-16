alias "jctl"="sudo journalctl -n 1000 -fu"

if ! type open &> /dev/null; then
	alias "open"="xdg-open"
fi
alias "op"="open"

alias "ssh"="kitty +kitten ssh"

export LESS="-Rj.5"

alias "ls"="ls --color=auto"
alias "l"="ls -l"
alias "lh"="l -h"
alias "la"="ls -la"
alias "lla"="ls -la"
alias "lc"="l --color"

alias "m"="l"
alias "o"="l"
alias "k"="l"

alias ls="exa --group"
alias lg="exa --git-ignore"
alias llg="exa -l --git-ignore"
