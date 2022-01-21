#!/usr/bin/env zsh
set -e
cd $(dirname $0)

link config/zsh/zshrc ~/.config/zsh/.zshrc

if [[ ! -e /etc/zsh/zshenv ]]; then
	info "Linking zshenv to /etc/zsh/zshenv (to enable the zshrc on the tty, requires root privileges)"
	sudo ln -s $(realpath zshenv) /etc/zsh/zshenv -f
fi
