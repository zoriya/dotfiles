bstrip()
{
	mkdir -p merged
	for file in *.mkv; do
		OUTPUT="$(dirname "$file")/merged/$(basename "$file")"
		mkvmerge -o "$OUTPUT" --subtitle-tracks "eng,fre" "$file"
	done
}