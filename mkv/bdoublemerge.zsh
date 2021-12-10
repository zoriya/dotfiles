bdoublemerge()
{
	if [[ -z "$1" || -z "$2" || -z "$3" || "$1" == "-h" ]]; then
		echo "Usage: bdoublemerger video_ext eng_sufix fre_sufix"
		return 1
	fi
	for file in *$1; do
		OUTPUT="$(dirname "$file")/merged/$(basename "$file")"
		SUB="${$(basename "$file" $1)%.*}"
		mkvmerge -o "$OUTPUT" --subtitle-tracks "eng,fre" "$file" --language 0:eng "$SUB$2" --language 0:fre "$SUB$3"
	done
}