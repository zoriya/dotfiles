#!/usr/bin/env zsh
set -e
cd $(dirname $0)

info "Linking zsh.hook to /etc/pacman.d/hooks/zsh.hook (requires sudo privilege)"
sudo ln -s $(realpath zsh.hook) /etc/pacman.d/hooks/zsh.hook -f