#!/bin/bash

path_of_file=$3

file_name="$path_of_file/enum.h"

#-- Grabs the %tokentemplate line --#
name=$(grep -i "%fileincludename" $1 | sed 's/[^ ]* //')

if [ -z "$name" ]; then
    echo "No %fileincludename provided. Going for enum.h"
else
    file_name="$name.h"
fi #TODO: add theses lines to includeGen !

if [ ! -f $1 ]; then #-- Checks if the input file given by the user exists --#
	echo -e "File \"$1\" not found!"
	exit 1
elif [[  -f $2  ]]; then #-- Checks if the output file doesnt already exists --#
	echo -e "File \"$2\" already exist!"
	exit 1
elif [[  -f $file_name  ]]; then #-- Checks if the output file doesnt already exists --#
	echo -e "File \"$file_name\" already exist!"
	exit 1
fi
touch $2