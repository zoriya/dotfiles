# Autocompletion selection (tab highlight + arrow move)
zstyle ':completion:*' menu select

# ^Z when a job is suspended runs it in the background.
background()
{
	bg
}
zle -N background
bindkey ^Z background

# Use run-help to access zsh manuels
(whence -w run-help | grep -q alias) && unalias run-help
autoload run-help

mkdir -p $XDG_STATE_HOME/zsh
mkdir -p $XDG_CACHE_HOME/zsh
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache
