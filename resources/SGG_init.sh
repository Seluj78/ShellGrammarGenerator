#!/bin/bash

if [ ! -f $1 ]; then #-- Checks if the input file given by the user exists --#
	echo -e "File \"$1\" not found!"
	exit 1
elif [[  -f $2  ]]; then #-- Checks if the output file doesnt already exists --#
	echo -e "File \"$2\" already exist!"
	exit 1
fi
touch $2