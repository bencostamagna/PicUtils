#! /bin/bash


usage() {
	echo "Usage: 	$0 [options] foldernames"
	echo "	$0 --help to list options"
}

print_help() {
	echo "Usage: 	$0 [options] foldernames"
	echo ""
	echo "Options"
	echo ""
	echo "	-h  | --help		Prints this help message"
	echo "	-r  | -R		Recursive"
	echo "	-dr | --dry-run		Tests file compression but keeps files unchanged on disk (implies verbose)"
	echo "	-q  | --quality	[1-100]	Sets target quality, 100 is best, 1 is worst, default is 85"
	echo "  -v  | -- verbose	Verbose mode"
	echo ""
}

print_info() {
	if [ $VERBOSE = true ]
	then
		echo $@
	fi
}

process_folder() {
	print_info "Converting Files in $1"
	for file in "$1"/*
	do
		if [ -f "$file" ] && [ $(file --mime-type -b "$file") = "image/jpeg" ]
		then
			quality=$(identify -format '%Q' "$file")
			if [ $quality -gt $QUALITY_TARGET ]
			then
				oldsize=$(du -h "$file" | cut -f1)
				convert -quality $QUALITY_TARGET "$file" "$file.tmp"
				newsize=$(du -h "$file.tmp" | cut -f1)
				print_info "	Compressing file $file: quality: $quality -> $QUALITY_TARGET, size: $oldsize -> $newsize"
				if [ $DO_NOTHING = true ]
				then
					rm "$file.tmp"
				else
					mv "$file.tmp" "$file"
				fi
			else
				print_info "	Ignoring file $file: quality: $quality is less than target $QUALITY_TARGET"
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
	exit 1
fi

RECURSIVE=false
DO_NOTHING=false
PRINT_HELP=false
VERBOSE=false
QUALITY_TARGET=85
while true;
do
	case "$1" in
    		-r | -R ) RECURSIVE=true; shift ;;
    		-dr | --dry-run ) DO_NOTHING=true; VERBOSE=true; shift ;;
    		-h | --help ) PRINT_HELP=true; shift ;;
		-q | --quality ) QUALITY_TARGET="$2"; shift; shift;;
		-v | --verbose ) VERBOSE=true; shift;;
    		-- ) shift; break ;;
    		* ) break ;;
  	esac
done

if [ $PRINT_HELP = true ]
then
	print_help
	exit 0
fi


for dir in "$@"
do
	if [ -d "$dir" ]
	then
		process_folder $dir
	fi
done


