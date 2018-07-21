#! /bin/bash


for dir in "$@"
do
	if [ -d "$dir" ]
	then
		echo "Converting Files in $dir"
		for file in "$dir"/*
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
			fi
		done
	fi
done


