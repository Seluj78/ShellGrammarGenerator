#!/bin/bash

#-- Gets the Nth ';' --#
get_line_n_semili()
{
	local number_of_semi=$1
	(( number_of_semi-- ))
	local ret_line=0
	local count=0

#-- reads every lines of file (second parameters), and count the number of ';' and number of line --#
	while read line
	do
		if [ "$line" = ";" ]; then
			(( count++ ))
		fi
		(( ret_line++ ))
		if [ $count = $number_of_semi ]; then
			break
		fi
	done < $2;
	echo -e $ret_line
}

#-- Output in file_output the "middle" of 3D tab --#
output_middle()
{
	local number_line=$1
	local count=0
	local count2=1

	#-- Cut everything before ":" --#
	cut -d':' -f2 $2 > tmp_output_middle

	#-- After first, number_line = the next ";" + 1 --#
	if [ $number_line != 1 ]; then
		number_line=$(get_line_n_semili "$number_line" tmp_output_middle)
		(( number_line++ ))
	fi

	#-- Gets the line string with variable --#
	line_string=$(sed $number_line!d tmp_output_middle)

	#-- Gets the number of words in line --#
	number_of_word=$(echo -e $line_string | wc -w)
	number_of_word=$(echo -e $number_of_word | tr -d ' ')

#-- Evry line, while you don't meet ';' --#
	while [ "$line_string" != ";" ]
	do
		printf "		{" >> $3
		#-- Every is output in file, excepted '|'  --#
		for word in $line_string
		do
			(( number_of_word-- ))
			#-- Condition for echap '|' --#
			if [ $word != "|" ]; then
				#-- Condition for display ',' or not --#
				if [ ! $number_of_word = 0 ]; then
					printf $word", " >> $3
				else
					printf $word >> $3
				fi
			fi
		done
		#-- Next line --#
		(( number_line++ ))
		line_string=$(sed $number_line!d tmp_output_middle)
		number_of_word=$(echo -e $line_string | wc -w)
		number_of_word=$(echo -e $number_of_word | tr -d ' ')
		#-- Condition for display ';' or not --#
		if [ "$line_string" != ";"  ]; then
			printf "},\n" >> $3
		else
			printf "}\n" >> $3
		fi
	done
	rm tmp_output_middle
}

get_first_word_of_line()
{
    #-- Gets the first line in the title (Its in the title ¯\_(ツ)_/¯) --#
    ret=$(echo -e $1 | awk '{print $1;}')
    echo -e $ret
}

    #-- Removes all the lines that starts with ';' or '|' --#
    grep -v "^\s*[|\;]\|^\s*$" $INPUT_TMP > tmp
    echo -e "{" >> $C_OUTPUT

    nb=$(cat tmp | wc -l)
    #-- Loops in the tmp file --#
    count=1
    while read line
    do
        first=$(get_first_word_of_line $line)
        echo -e "	[$first] =" >> $C_OUTPUT
        echo -e "	{" >> $C_OUTPUT
        output_middle $count $INPUT_TMP $C_OUTPUT
        if [ $count != $nb ]; then
            echo -e "	}," >> $C_OUTPUT
        else
            echo -e "	}" >> $C_OUTPUT
        fi
        (( count++ ))
    done < tmp;
    echo -e "};" >> $C_OUTPUT
	rm tmp
    #-- write it into the file --#
