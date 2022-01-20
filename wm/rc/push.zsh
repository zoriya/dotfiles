rcpush()
{
	(cd $DOTFILES && push "$*")
}

rcs()
{
	(cd $DOTFILES && s)
}

rcdiff()
{
	(cd $DOTFILES && gd)
}

rcpull()
{
	(cd $DOTFILES && gp)
}

alias src="exec zsh"