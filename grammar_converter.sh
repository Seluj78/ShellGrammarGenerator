#!/bin/sh

help()
{
	echo "\nUsage:  ./grammar_converter.sh [input_file] [desired_output_file.h]"
	echo
	echo "\t\033[1;mExample: ./grammar_converter.sh grammar.file grammar.h\033[0m"
}

init()
{
	if [ ! -f $1 ]; then
		echo "File $1 not found!"
		exit 1
	fi
	if [ ! -f grammar_converter.sh ]; then
		echo "Grammar_converter has to be executed in his directory!"
		exit 1
	fi
	touch $2
}


rm_info()
{
	sed -i.bak '/^%/d' $1
	rm $1.bak
	sed -i.bak '/^$/d' $1
	rm $1.bak
}

replace_info()
{
    start=$(awk '/%%/{ print NR; exit }' $1)
    (( start++ ))
    count=0
    line=$(sed ''"$2"'!d' $1)
    for word in $line
    do
        if [ $count = 1 ]; then
            old=$word
        elif [ $count = 2 ]; then
            new=$word
        fi
        (( count++ ))
    done
    #echo $start
    #echo $old $new $2
    sed -i.bak ''"$start"',$s,'"$old"','"$new"',' "$1"
    rm $1.bak
}

parse_info()
{
   token_number=$(grep -c "%token" $1)
   #token_number = number of tokens to parse and replace

    n=1
    while [ $n -le $token_number ]
    do
        replace_info $1 $n
        (( n++ ))
    done
    rm_info $1
    #cat $1
}


#TODO : Use copy of grammar file to edit it and parse it and not original one

if [ $# = 0 ]; then
	help
	exit 1
elif [ $# = 1 ]; then
	help
	exit 1
elif [ $# = 2 ]; then
	echo "The input file is $1 and the output file is $2"
	init $1 $2
	parse_info $1
	exit 1
else
	echo "Grammar_converter.sh: Error: To many arguments"
	exit 1
fi
