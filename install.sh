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