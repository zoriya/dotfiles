#!/usr/bin/env zsh
set -e
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
	echo "Usage: $0 [-yih] [topics]"
	echo "\t-i: Install configs, link files..." 
	echo "\t-y: Install needed packages via yay."
	echo "\t-h: Show this help message."
	echo "Topics:"
	echo */ | xargs -L1 echo -e \\t
}

packages()
{
	info "Installing packages via yay... (requires sudo privilege)"
	yay -S --needed $(cat packages.txt)
}

install()
{
	for topic in $(find . -mindepth 1 -maxdepth 1 -type d -not -name '.*'); do
		if [[ ${topic##*.} == "ln" ]]; then
			dest=~/.$(basename ${topic%.*})
			link $topic $dest
		elif [[ -f $topic/Makefile ]]; then
			info "Running Makefile for $topic"
			sudo make -C $topic install
		elif [[ -f $topic/install.sh ]]; then
			cwd=$(pwd)
			source $topic/install.sh
			cd $cwd
		else
			for file in $(find $topic -type f -not -name '*.zsh' -or -type d -path '*.ln' -prune); do
				dest=~/.$(realpath --relative-to $topic $file)
				[[ -d $file ]] && dest=${dest%.*}
				link $file $dest
			done
			# TODO support with or without X
		fi
	done
	info "DONE."
}

OPTS=$(getopt --options "iyh" --long "install,yay,help" --name $0 -- $@)
eval set -- $OPTS

shouldInstall=""
shouldPackages=""
while true; do
	case $1 in
	-i | --install) shouldInstall=true; shift ;;
	-y | --yay) shouldPackages=true; shift ;;
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
TOPICS=$([[ $#@ -eq 0 ]] && echo */ || echo $@)
for topic in $TOPICS do
	cd $topic
	[[ ! -z $shouldPackages ]] && packages
	[[ ! -z $shouldInstall ]] && install
	cd $cwd
done
