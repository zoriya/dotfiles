cbuild()
{
	SOURCEDIR=$(pwd)
	BUILDDIR=${1:="build"}
	mkdir -p $BUILDDIR && cd $BUILDDIR && cmake $SOURCEDIR && bear -- make -j $2
	RET=$?
	cd $SOURCEDIR
	(exit $RET)
}

alias "gpp"="g++"
alias "gdb"="gdb -q"
