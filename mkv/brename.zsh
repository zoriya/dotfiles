brename()
{
	if [[ (-z "$1" && -z "$2") || "$1" == "-h" ]]; then
		echo "Usage: brename \"part_of_the_file_to_change\" \"new_part\" [\"extension\"] \"[count=0]\""
		return 1
	fi
	for file in *$~3; do
		if [[ $4 == 0 ]]; then
			if [[ -z $1 ]]; then
				mv -i "$file" "$2$file"
			else
				mv -i "$file" "${file//$1/$2}"
			fi
		else
			if [[ -z "$4" ]]; then
				COUNT=1
			else
				COUNT=$(($4 - 1))
			fi
			mv -i "$file" "$(echo ${file//$1/$2} | cut -c 1-$(($(echo $2 | wc -c) + $COUNT)))$3"
		fi
	done
}