bencode()
{
	if [[ $1 == "-h" ]]; then
		echo "Usage: bencode"
		return
	fi
	mkdir --parent encoded
	for file in *.mkv; do
		OUTPUT="$(dirname "$file")/encoded/$(basename "$file")"
		ffmpeg -i $file -map V? -map a? -map s? -map d? -map t? -c:v libx264 -filter:v format=yuv420p -c:a copy -c:s copy $OUTPUT
	done
	echo "$1"
}