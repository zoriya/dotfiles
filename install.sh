#!/usr/bin/env zsh
set -eu
cd $(dirname $0)
source cli/profile/config/profile

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
	echo "Usage: $0 [-yish] [topics]"
	echo "\t-i: Install configs, link files..." 
	echo "\t-y: Install needed packages via yay."
	echo "\t-s: Clone submodules."
	echo "\t-h: Show this help message."
	echo "Topics:"
	ls -d */ | xargs -L1 echo -e \\t
}

packages()
{
	info "Installing packages via yay... (requires sudo privilege)"
	yay -S --needed $(cut -d\# -f1 packages.txt)
}

install()
{
	[[ -f install.sh ]] && source install.sh
	for topic in $(find . -mindepth 1 -maxdepth 1 -type d -not -name '.*'); do
		if [[ ${topic##*.} == "ln" ]]; then
			local dest=~/.$(basename ${topic%.*})
			link $topic $dest
		elif [[ -f $topic/Makefile ]]; then
			info "Running Makefile for $topic"
			sudo make -C $topic install
		elif [[ -f $topic/install.sh ]]; then
			local cwd=$(pwd)
			source $topic/install.sh
			cd $cwd
		else
			for file in $(find $topic -type f -not -name '*.zsh' -or -type d -path '*.ln' -prune); do
				local dest=~/.$(realpath --relative-to $topic $file)
				[[ -d $file ]] && dest=${dest%.*}
				link $file $dest
			done
		fi
	done
}

OPTS=$(getopt --options "iysh" --long "install,yay,submodule,help" --name $0 -- $@)
eval set -- $OPTS

shouldInstall=""
shouldPackages=""
while true; do
	case $1 in
	-i | --install) shouldInstall=true; shift ;;
	-y | --yay) shouldPackages=true; shift ;;
	-s | --submodule) git submodule update --init; shift ;;
	-h | --help) usage; exit 0 ;;
	--) shift; break ;;
	*) usage; exit 2 ;;
	esac
done

if [[ "x$shouldInstall" == "x" && "x$shouldPackages" == "x" ]]; then
	shouldInstall=true
	shouldPackages=true
fi

cwd=$(pwd)
TOPICS=($([[ $#@ -eq 0 ]] && ls -d */ || ls -d $@))
for topic in $TOPICS; do
	cd $topic
	[[ ! -z $shouldPackages ]] && packages
	[[ ! -z $shouldInstall ]] && install
	cd $cwd
done
