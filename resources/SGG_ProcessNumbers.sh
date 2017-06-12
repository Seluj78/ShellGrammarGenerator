#!/bin/bash

	### LOCAL VAR ###
    actual=0
    max_pipe=0
    max_comma=0
	#################

		### SET/GET MAX_PIPE ###
    #-- Reads every line, and everytime one starts with a '|', reads it to see if it has the most words in it --#
    while read line
    do
        if [[ ${line:0:1} == "|" ]]; then
            (( actual++ ))
        else
            if [ $max_pipe -lt $actual ]; then
                max_pipe=${actual}
            fi
            actual=0
        fi
    done < $INPUT_TMP;
		#########################


		### SET/GET MAX_COMMA ###
    #-- save 1 in tmp --#
    cat $INPUT_TMP > tmp

    #-- Cuts everything before : and then the first char of every line --#
    cut -d':' -f2 tmp > tmp1
    cut -c 2- tmp1 > tmp2

    #-- This one, since everything is cut off, reads the line and gets the highest word count --#
    while read line_2
    do
        actual=$(echo -e $line_2 | wc -w)
        if [ $max_comma -lt $actual ]; then
            max_comma=${actual}
        fi
        actual=0
    done < tmp2;
    rm tmp tmp1 tmp2
		#########################

    count=$(cat count)
    #-- trims the trailing whitespaces --#
    max_comma=$(echo -e $max_comma | tr -d ' ')
    max_pipe=$(($max_pipe + 1))
	#-- echo -ees into the file the numbers we got --#
	echo -e >> $C_OUTPUT
	echo -e "uint32_t    grammar[$count][$max_pipe][$max_comma]=" >> $C_OUTPUT