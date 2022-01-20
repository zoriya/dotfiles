bvtt()
{
	mkdir -p output
	for file in *.vtt; do
		OUTPUT="$(dirname "$file")/output/$(basename "$file")"
		OUT=${OUTPUT//vtt/srt}
		echo "ffmpeg -i \"$file\" \"$OUT\""
	done
}