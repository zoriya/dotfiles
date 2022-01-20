#!/usr/bin/env zsh
set -e
cd $(dirname $0)

sudolink()
{
	[[ -z $3 && $(readlink -f $1) == $(realpath $2) ]] && return
	[[ ! -z $3 && -e $2 ]] && return
	info "Linking $1 to $2 (requires sudo privilege)"
	sudo $([[ ! -z $3 ]] && echo $3 || echo ln -s) $(realpath $1) $2 -f
}

sudolink "startdwm" "/usr/bin/startdwm"
sudo mkdir -p /usr/share/xsessions
sudolink "dwm.desktop" "/usr/share/xsessions/dwm.desktop" cp
