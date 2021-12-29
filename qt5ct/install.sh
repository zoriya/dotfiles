#/usr/bin/env zsh
set -e
cd $(dirname $0)

ln -s $(realpath qt5ct/qt5ct.conf) ~/.config/qt5ct/qt5ct.conf -f
ln -s $(realpath Material-Ocean/colors/Material-Ocean.conf) ~/.config/qt5ct/colors -f
ln -s $(realpath Material-Ocean/colors/Material-Ocean.conf) ~/.config/qt5ct/colors -f