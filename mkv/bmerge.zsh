
bmerge()
{
	if [[ -z "$1" || -z "$2" || -z "$3" || "$1" == "-h" ]]; then
		echo "Usage: bmerger video_ext sub_ext lang [contain_multiple_subs] [delay]"
		echo -e "\tcontain_multiple_subs: true if the video file has more than one subtitle track."
		echo -e "\tSupported languages: eng, fre, mul (take .eng\$(sub_ext) and .fre\$(sub_ext))"
		return 1
	fi
	if [[ $3 != "fre" && $3 != "eng" && $3 != "mul"  ]]; then
		echo "bmerger: supported languages: eng, fre, mul"
		return 1
	fi
	if [[ $3 == "fre"  ]]; then; OL="eng"; else; OL="fre"; fi
	DELAY=${5:-$4}
	DELAY=${DELAY:-0}
	if ! [[ $DELAY =~ '^-?[0-9]+$' ]]; then; DELAY=0; fi
	echo "Merging with delay: $DELAY"
	mkdir --parent merged
	
	FONTS=()
	if [[ -d fonts ]]; then
		for font in fonts/*; do
			FONTS+=(--attachment-mime-type $(file -b --mime-type "$font") --attach-file "$font")
		done
	fi

	for file in *$1; do
		OUTPUT="$(dirname "$file")/merged/$(basename "$file" $1).mkv"

		if [[ $3 == "mul" ]]; then
			ENG_SUB="$(basename "$file" $1).eng$2"
			FRE_SUB="$(basename "$file" $1).fre$2"
			if [[ ! -f $ENG_SUB || ! -f $FRE_SUB ]]; then; 
				echo "bmerger: Missing subtitle for $file, ignoring."
				continue
			fi
			mkvmerge -o "$OUTPUT" -S "$file" --default-track 0 -y 0:$DELAY --language 0:eng "$ENG_SUB" -y 0:$DELAY --language 0:fre "$FRE_SUB" $FONTS
			continue
		fi

		SUB="$(basename "$file" $1)$2"
		if [[ -f $SUB  ]]; then
			if [[ $4 == "true" ]]; then
				mkvmerge -o "$OUTPUT" -s $OL "$file" -y 0:$DELAY --language 0:$3 "$SUB" $FONTS
			else
				mkvmerge -o "$OUTPUT" --default-track 2 --language 2:$OL "$file" -y 0:$DELAY --language 0:$3 "$SUB" $FONTS
			fi
		else
			echo "bmerger: no subtitles found for $file, ignoring."
		fi
	done
}