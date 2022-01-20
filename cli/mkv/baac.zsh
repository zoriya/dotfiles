baac()
{
	if [[ $1 == "-h" ]]; then
		echo "Usage: baac [channel]\n\tset channel to true if your input has more than 2 channels."
		return;
	fi
	mkdir --parent encoded
	for file in *.mkv; do
		OUTPUT="$(dirname "$file")/encoded/$(basename "$file")"
		if [[ $1 == "true" ]]; then
			ffmpeg -i $file -map 0 -c:v copy -c:a aac -ac 2 -af "pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR" -c:s copy $OUTPUT
		else
			ffmpeg -i $file -map 0 -c:v copy -c:a aac -c:s copy $OUTPUT
		fi
	done
}