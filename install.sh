#!/usr/bin/env zsh
set -e
cd $(dirname $0)

info()
{
	printf "\r[ \033[00;34m..\033[0m ] $*\n"
}

warn()
{
	printf "\r[ \033[00;31m!!\033[0m ] $*\n"
}

link()
{
	file=$1
	dest=$2
	[[ $(readlink -f $dest) == $(realpath $file) ]] && return
	info "Linking $file to $dest"
	if [[ -e $dest ]]; then
		warn "File $dest already exists. Moving it to ~/bak/"
		mkdir -p ~/bak
		mv $dest ~/bak -f
	fi
	mkdir -p $(dirname $dest)
	ln -s $(realpath $file) "$dest" -f
}

usage()
{
	echo "Usage: $0 [-i]"
	echo "\t-i: Install configs, link files..." 
	echo "\t-c: Run the one-time configuration script" 
	echo "\t-d: Clone dependencies (oh-my-zsh, powerlevel10k...)"
	echo "\t-y: Install needed packages via yay."
	echo "\t-h: Show this help message."
	exit 0
}

dependencies()
{
	clone()
	{
		if [[ ! -d "$1" ]]; then
			info "Clonning $(basename $1)..."
			git clone "$2" "$1"
		fi
	}

	info "Installing dependencies..."

	local ZSH_CUSTOM=~/.oh-my-zsh/custom

	clone ~/.oh-my-zsh                                git@github.com:ohmyzsh/ohmyzsh.git
	clone $ZSH_CUSTOM/themes/powerlevel10k            git@github.com:romkatv/powerlevel10k.git
	clone $ZSH_CUSTOM/plugins/zsh-completions         git@github.com:zsh-users/zsh-completions
	clone $ZSH_CUSTOM/plugins/zsh-autosuggestions     git@github.com:zsh-users/zsh-autosuggestions
	clone $ZSH_CUSTOM/plugins/zsh-syntax-highlighting git@github.com:zsh-users/zsh-syntax-highlighting.git

	if [[ ! -e ~/.localrc ]]; then
		cat > ~/.localrc <<- eof
		export OMZ="$HOME/.oh-my-zsh"
		export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
		eof
	fi
}

packages()
{
	info "Installing packages via yay... (requires sudo privilege)"
	yay -S --needed $(cat packages.txt)
}

install()
{
	for topic in $(find . -mindepth 1 -maxdepth 1 -type d -not -name '.*'); do
		if [[ ${topic##*.} == "ln" ]]; then
			dest=~/.$(basename ${topic%.*})
			link $topic $dest
		elif [[ -f $topic/Makefile ]]; then
			info "Running Makefile for $topic"
			sudo make -C $topic install
		elif [[ -f $topic/install.sh ]]; then
			cwd=$(pwd)
			source $topic/install.sh
			cd $cwd
		else
			for file in $(find $topic -type f -not -name '*.zsh' -or -type d -path '*.ln' -prune); do
				dest=~/.$(realpath --relative-to $topic $file)
				[[ -d $file ]] && dest=${dest%.*}
				link $file $dest
			done
			# TODO support with or without X
		fi
	done
	info "DONE."
}

config()
{
	info "Setting google-chrome as the default browser"
	xdg-settings set default-web-browser google-chrome.desktop
	[[ -e ~/.ssh/*.pub ]] || { info "Generating an ssh-key since none exists"; ssh-keygen }
	#[[ -e ~/.ssh/*.pub ]] || { info "Generating an gpg-key since none exists.\
#\nSee https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key for more details"; gpg --full-generate-key }
}

while getopts "dix" opt; do
	case $opt in
	d) dependencies ;;
	i) install ;;
	y) packages ;;
	c) config ;;
	x) echo "Not Implemented yet."; exit 1 ;;
	*) usage ;;
	esac
done

