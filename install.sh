#!/usr/bin/env zsh
set -e

if [[ "$1" == "-h" ]]; then
	echo "Usage: $0 [-i]"
	echo "\t-i: Clone dependencies (oh-my-zsh, powerlevel10k...)"
	exit 0
fi

cd $(dirname $0)

info()
{
	printf "\r[ \033[00;34m..\033[0m ] $*\n"
}

warn()
{
	printf "\r[ \033[00;31m!!\033[0m ] $*\n"
}

for file in $(find */ -type f -not -name '*.zsh'); do
	dest=~/.$(basename $file)
	if [[ $(readlink -f $dest) == $file ]]; then
		info File already linked ($file). Skipping...
		break
	fi
	info Linking $file
	if [[ -e $dest ]]; then
		warn File $dest already exists. Moving it to ~/bak/
		mv $dest ~/bak -f
	fi
	ln -s $(realpath $file) "$dest" -f
done

clone()
{
	if [[ ! -d "$1" ]]; then
		git clone "$2" "$1"
	fi
}

if [[ "$1" == "-i" ]]; then
	local ZSH_CUSTOM=~/.oh-my-zsh/custom

	clone ~/.oh-my-zsh                                git@github.com:ohmyzsh/ohmyzsh.git
	clone $ZSH_CUSTOM/themes/powerlevel10k            git@github.com:romkatv/powerlevel10k.git
	clone $ZSH_CUSTOM/plugins/zsh-syntax-highlighting git@github.com:zsh-users/zsh-syntax-highlighting.git
fi