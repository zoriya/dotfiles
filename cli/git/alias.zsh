push()
{
	if [[ -z "$1" ]]; then
		git push
		return
	fi
	git add -A && git commit -m "$*" && git push
}

alias "s"="git status"
alias "gp"="git pull"
alias "gf"="git fetch"
alias "gd"="git diff"