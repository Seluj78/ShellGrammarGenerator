#!/bin/bash

if [ ! -f $INPUT ]; then #-- Checks if the input file given by the user exists --#
	echo -e "File \"$INPUT\" not found!"
	exit 1
elif [[  -f $C_OUTPUT  ]]; then #-- Checks if the output file doesnt already exists --#
	echo -e "File \"$C_OUTPUT\" already exist!"
	exit 1
elif [[  -f $H_OUTPUT  ]]; then #-- Checks if the output file doesnt already exists --#
	echo -e "File \"$H_OUTPUT\" already exist!"
	exit 1
fi
touch $C_OUTPUT