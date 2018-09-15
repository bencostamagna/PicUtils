# PicUtils
Utility to compress images from my camera

The utility goes through all the folders given as argument and compresses any JPEG image.
By default, the quality is set to 85, but this can be modified by using the -q option.

## Usage:
./compress.sh [options] foldernames

## Options
 -h  | --help			Prints this help message
 
 -r  | -R  			Recursive
 
 -dr | --dry-run  		Tests file compression but keeps files unchanged on disk
 
 -q  | --quality [1-100] 	Sets target quality, 100 is best, 1 is worst, default is 85
 

