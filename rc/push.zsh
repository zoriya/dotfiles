rcpush()
{
	(cd $DOTFILES && push "$*")
}

rcs()
{
	(cd $DOTFILES && s)
}

rcpull()
{
	(cd $DOTFILES && gp)
}