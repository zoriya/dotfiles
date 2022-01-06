#!/usr/bin/env zsh
set -e
cd $(dirname $0)

source profile/config/profile

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
	echo "\t-y: Install needed packages via yay."
	echo "\t-h: Show this help message."
	exit 0
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
	mkdir -p $XDG_STATE_HOME
	info "Setting google-chrome as the default browser"
	xdg-settings set default-web-browser google-chrome.desktop
	[[ -e ~/.ssh/*.pub ]] || { info "Generating an ssh-key since none exists"; ssh-keygen }
	#[[ -e $XDG_CONFIG_HOME/gnpug/?? ]] || { info "Generating an gpg-key since none exists.\
#\nSee https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key for more details"; gpg --full-generate-key }
}

while getopts "diycxh" opt; do
	case $opt in
	i) install ;;
	y) packages ;;
	c) config ;;
	x) echo "Not Implemented yet."; exit 1 ;;
	*) usage ;;
	esac
done

