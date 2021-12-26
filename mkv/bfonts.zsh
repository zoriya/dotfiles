bfonts()
{
	case $1 in
	e)
		mkdir -p fonts
		cd fonts
		for file in ../*$2; do
			fonts=$(mkvmerge -i "$file" | grep Attachment | awk  '{print $3$11}' | tr -d \')
			mkvextract "$file" attachments ${=fonts}
		done
		cd ..
		;;
	a)
		FONTS=()
		for font in fonts/*; do
			FONTS+=(--attachment-mime-type $(file -b --mime-type "$font") --attach-file "$font")
		done

		mkdir -p output
		for file in *$2; do
			mkvmerge $file -o output/$file $FONTS
		done
		;;
	*)
		echo "To extract: bfonts e. To attach bfonts a"
		echo "Usage: bfonts <e|a> [files_filter]"
		return 2
		;;
	esac
}
