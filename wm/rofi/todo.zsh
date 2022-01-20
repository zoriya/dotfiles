# This alias is also used by the todo.sh script (inside the .config/rofi folder)
alias todogit='git --work-tree=$(dirname $TODO_FILE) --git-dir=$TODO_GIT'

todoinit()
{
	if [[ -z $1 || -z $2 || -z $3 || $1 == -h  ]]; then
		echo "Usage: todoinit <todo_file_path> <todo_git_path> <todo_git_remote>"
		return 2
	fi

	cat > $XDG_CONFIG_HOME/zsh/localrc  <<- eof
	
	TODO_FILE=$1
	TODO_GIT=$2

	eof
	source $XDG_CONFIG_HOME/zsh/localrc
	git clone --bare $3 $2
	todogit reset $(basename $1)
	[[ -e $1 ]] || touch $1
	todogit add $1
	info "Initialization done."
}
