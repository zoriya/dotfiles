#!/usr/bin/env zsh

cd $($dirname $0)

for file in $(find */ -type f -not '*.zsh'); do
	echo $file
	ln -s $file ~/.$(basename $file)
done