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

usage() {
	echo "Usage: $0 [-i]"
	echo "\t-d: Clone dependencies (oh-my-zsh, powerlevel10k...)"
	echo "\t-x: Install things for an X server (fonts, dwm, redshift...)"
	echo "\t-h: Show this help message."
	exit 0
}

dependencies() {
	clone()
	{
		if [[ ! -d "$1" ]]; then
			info "Clonning $(basename $1) ..."
			git clone "$2" "$1"
		fi
	}
	
	info "Installing dependencies..."

	local ZSH_CUSTOM=~/.oh-my-zsh/custom

	clone ~/.oh-my-zsh                                git@github.com:ohmyzsh/ohmyzsh.git
	clone $ZSH_CUSTOM/themes/powerlevel10k            git@github.com:romkatv/powerlevel10k.git
	clone $ZSH_CUSTOM/plugins/zsh-completions         git@github.com:zsh-users/zsh-completions 
	clone $ZSH_CUSTOM/plugins/zsh-syntax-highlighting git@github.com:zsh-users/zsh-syntax-highlighting.git

	if [[ ! -e ~/.localrc ]]; then
		cat > ~/.localrc <<- eof
		export OMZ="$HOME/.oh-my-zsh"
		export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
		eof
	fi
}

install() {
	for topic in $(find . -mindepth 1 -maxdepth 1 -type d -not -name '.*'); do
		if [[ ${topic##*.} == "ln" ]]; then
			dest=~/.$(basename ${topic%.*})
			[[ -f $dest ]] \
				&& warn "$dest already exists." \
				|| info "Linking $dest" && ln -s $(realpath $topic) $dest
		elif [[ -f $topic/Makefile ]]; then
			info "Running Makefile for $topic (commented for now)"
			#make -C $topic install
		elif [[ -f $topic/install.sh ]]; then
			info "Running install.sh for $topic"
			$topic/install.sh
		else
			for file in $(find $topic -type f -not -name '*.zsh' -or -type d -path '*.ln' -prune); do
				dest=~/.$(realpath --relative-to $topic $file)
				[[ -d $file ]] && dest=${dest%.*}

				[[ $(readlink -f $dest) == $(realpath $file) ]] && break
				info "Linking $file"
				if [[ -e $dest ]]; then
					warn "File $dest already exists. Moving it to ~/bak/"
					mkdir -p ~/bak
					mv $dest ~/bak -f
				fi
				ln -s $(realpath $file) "$dest" -f
			done
			# TODO support with or without X
		fi
	done
}

while getopts "dx" opt; do
	case $opt in
	d) dependencies ;;
	x) echo "Not Implemented yet." ;;
	*) usage ;;
	esac
done

install

# TODO pacman/zsh.hook location.

# TODO clean up this huge chunk
info "toto"
sudo ln -s "$(realpath startdwm)" /usr/bin/startdwm -f
sudo ln -s "$(realpath dwm.desktop)" /usr/share/xsessions/dwm.desktop -f
sudo ln -s "$(realpath fonts)" /usr/local/share/fonts -f
sudo ln -s /etc/fonts/conf.avail/10-scale-bitmap-fonts.conf /etc/fonts/conf.d/

info "DONE."
