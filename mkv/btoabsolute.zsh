btoabsolute()
{
	if [[ -z "$1" || "$1" == "-h" ]]; then
		echo "Usage: btoabsolute nbr_to_add [\"extension\"]"
		return 1
	fi
	for file in *$2; do
		NBR=`echo $file | grep -Eo "[0-9]+" | tail -1`
		NEW_NBR=$(($NBR + $1))
		mv -i "$file" "${file//$NBR/$NEW_NBR}"
	done
}
