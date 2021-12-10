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