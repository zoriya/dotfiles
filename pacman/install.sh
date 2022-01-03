#!/usr/bin/env zsh
set -e
cd $(dirname $0)

dest=/etc/pacman.d/hooks/zsh.hook
info "Linking zsh.hook to $dest (requires sudo privilege)"
[[ ! -e $dest ]] && sudo ln -s $(realpath zsh.hook) $dest -f!
