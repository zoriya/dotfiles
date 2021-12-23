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

# TODO pacman/zsh.hook location.
# for file in $(find */ -type f -not -name '*.zsh'); do
# 	dest=~/.$(basename $file)
# 	if [[ $(readlink -f $dest) == $file ]]; then
# 		info File already linked ($file). Skipping...
# 		break
# 	fi
# 	info Linking $file
# 	if [[ -e $dest ]]; then
# 		warn File $dest already exists. Moving it to ~/bak/
# 		mv $dest ~/bak -f
# 	fi
# 	ln -s $(realpath $file) "$dest" -f
# done

# TODO clean up this huge chunk
ln -s "$(realpath zsh/zshrc)" ~/.zshrc -f
ln -s "$(realpath zsh/profile)" ~/.profile -f
ln -s "$(realpath X11/xinitrc)" ~/.xinitrc -f
ln -s "$(realpath X11/Xresources)" ~/.Xresources -f
ln -s "$(realpath wallpapers)" ~/.wallpapers -f
ln -s "$(realpath dunst/config)" ~/.config/dunst -f
ln -s "$(realpath sxhkd/config)" ~/.config/sxhkd -f
ln -s "$(realpath rofi/config)" ~/.config/rofi -f
ln -s "$(realpath kitty/config)" ~/.config/kitty -f
ln -s "$(realpath flameshot/config)" ~/.config/flameshot -f
ln -s "$(realpath fontconfig/config)" ~/.config/fontconfig -f
sudo ln -s "$(realpath startdwm)" /usr/bin/startdwm -f
sudo ln -s "$(realpath dwm.desktop)" /usr/share/xsessions/dwm.desktop -f
sudo ln -s "$(realpath fonts)" /usr/local/share/fonts -f
sudo ln -s /etc/fonts/conf.avail/10-scale-bitmap-fonts.conf /etc/fonts/conf.d/

clone()
{
	if [[ ! -d "$1" ]]; then
		info "Clonning $(basename $1) ..."
		git clone "$2" "$1"
	fi
}

if [[ "$1" == "-i" ]]; then
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
fi

info "DONE."
