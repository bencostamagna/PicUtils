#! /bin/bash


usage() {
	echo "Usage: ./compress [-r] foldernames"
}


process_folder() {
	echo "Converting Files in $1"
	for file in "$1"/*
	do
		if [ -f "$file" ]
		then
			if [ "$(stat -c%s "$file")" -ge 5000000 ]
			then
				oldsize=$(du -h "$file" | cut -f1)
				convert -quality 85 "$file" "$file"
				newsize=$(du -h "$file" | cut -f1)
				echo "Compressing file $file: $oldsize -> $newsize"
			fi
		elif [ $RECURSIVE = true ] && [ -d "$file" ]
		then
			process_folder "$file"
		fi
	done
}

if [ $# -eq 0 ]
then
	usage
fi

RECURSIVE=false
while true;
do
	case "$1" in
    		-r | -R ) RECURSIVE=true; shift ;;
    		-- ) shift; break ;;
    		* ) break ;;
  	esac
done



for dir in "$@"
do
	if [ -d "$dir" ]
	then
		process_folder $dir
	fi
done


