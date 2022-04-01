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
alias "gP"="git push"
alias "gl"="git log"
alias "gf"="git fetch"
alias "gd"="git diff"
