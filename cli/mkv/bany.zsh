bany()
{
	if [[ -z $1 ||"$1" == "-h" ]]; then
		echo "Usage: bany command [extension_filter]"
		echo "\t'\$file' will be replaced with the name of a file"
		echo "\t'\$output' will be replaced with the name of the outfile"
		return;
	fi
	mkdir -p output
	for file in *$~2; do
		output="$(dirname "$file")/output/${$(basename "$file"):r}.mkv"
		echo "${(e)1}"
	done
}
