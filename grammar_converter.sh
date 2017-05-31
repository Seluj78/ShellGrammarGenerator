#!/bin/sh

################################################################################
#                              BASES FUNCTIONS                                 #
################################################################################


#-- Help display function --#
help()
{
	echo "\nUsage:  ./grammar_converter.sh [input_file] [desired_output_file.h]"
	echo "\t\033[1;mExample: ./grammar_converter.sh -i grammar.file -o grammar.h\033[0m"
	echo
	echo "\t\033[1m-i --input\033[0m  (required), used to specify the grammar file (in yacc format). If not set, will display an error"
	echo "\t\033[1m-o --output\033[0m (optional), if not set, grammar_converter will output into grammar.c and grammar.h files"
	echo "\t\033[1m-h --help\033[0m   (help) Will display help"
}

#-- Init display funtion --#
init()
{
	if [ ! -f $file_input ]; then #-- Checks if the input file given by the user exists --#
		echo "File \"$file_input\" not found!"
		exit 1
	elif [[  -f $file_output  ]]; then #-- Checks if the output file doesnt already exists --#
		echo "File \"$file_output\" already exist!"
		exit 1
	fi
	touch $file_output
}

################################################################################
#                              INFO TOKEN FUNCTION                             #
################################################################################

rm_info()
{
    #-- Removes every line that starts with a % (info) --#
	sed -i.bak '/^%/d' $1
	rm $1.bak
	#-- Removes every blank line/line filled with whitespaces --#
	sed -i.bak '/^$/d' $1
	rm $1.bak
}

replace_info()
{
    #-- Get the start line number (%%) --#
	start=$(awk '/%%/{ print NR; exit }' $file_input_tmp)
	(( start++ ))

    #-- TODO: REDO THIS --#
	count=0
	line=$(sed ''"$1"'!d' $file_input_tmp)
	for word in $line
	do
		if [ $count = 1 ]; then #TODO: fix line 50 of tmpfile !!!!
			old=$word
		fi
		(( count++ ))
	done

	#-- Concatenates the two strings --#
    new="$2""$old"

    #-- Replaces the token with the 'templated' token --#
    sed -i.bak ''"$start"',$s,'"$old"','"$new"',' "$file_input_tmp"

    #-- removes the .bak file --#
	rm $file_input_tmp.bak
}

parse_info()
{
    #-- Gets the number of tokens to be replaced --#
	token_number=$(grep -c "%token" $file_input_tmp)

	#-- Gets the line where the %tokentemplate is --#
    grep -i "%tokentemplate" $file_input_tmp > tmp

    #-- Gets just the template (removes everything before the space) --#
    template=$(sed 's/[^ ]* //' tmp)
	n=1

	#-- Loops in the file and replaces the tokens --#
	while [ $n -le $token_number ]
	do
		replace_info $n $template
		(( n++ ))
	done

	#-- Removes temporary file --#
	rm tmp
}

get_include()
{
    #-- Gets at line $1 the second word (everything after the %include) --#
    var=$(sed ''"$1"'q;d' $file_input_tmp | awk  '{print $2}')

    #-- echo is used to return a value --#
    echo $var
}

parse_includes()
{
    #-- Finds the first include line --#
    include_line=$(grep -n "%include" $file_input_tmp |head -n 1 |cut -d':' -f1)

    #-- Finds the number of includes to process --#
    include_number=$(grep -c "%include" $file_input_tmp)
    count=0
    str=""

    #-- Loops into the %includes and process them then adds them in the str variable --#
    for (( c=$include_line; $count < $include_number; c++ ))
    do
        str="$str $(get_include $c)"
        (( count++ ))
    done

    #-- return the str variable --#
    echo $str
}

################################################################################
#                              GENERATOR OUTPUT                                #
################################################################################



output_include()
{
    #-- Prints all the includes --#
	for header in ${needed_include} ; do
		echo "#include <$header>" >> $file_output
	done
}

get_start()
{
    #-- Gets the start name --#
    name_start=$(awk '{for (I=1;I<=NF;I++) if ($I == "%start") {print $(I+1)};}' $file_input_tmp)
}


process_grammar()
{
    #-- Call all functions to process grammar --#
	output_include
	get_start
	rm_info $file_input_tmp
}

process_numbers()
{
    actual=0
    max_pipe=0
    max_comma=0

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
    done < $file_input_tmp;

    #-- save file_input_tmp in tmp --#
    cat $file_input_tmp > tmp

    #-- Cuts everything before : and then the first char of every line --#
    cut -d':' -f2 tmp > tmp1
    cut -c 2- tmp1 > tmp2

    #-- This one, since everything is cut off, reads the line and gets the highest word count --#
    while read line_2
    do
        actual=$(echo $line_2 | wc -w)
        if [ $max_comma -lt $actual ]; then
            max_comma=${actual}
        fi
        actual=0
    done < tmp2;

    rm tmp tmp1 tmp2

    #-- trims the trailing whitespaces --#
    max_comma=$(echo $max_comma | tr -d ' ')

    max_pipe=$(($max_pipe + 1))

    #-- echoes into the file the numbers we got --#
    echo "\nuint32_t    grammar[][$max_pipe][$max_comma]=" >> $file_output
    #TODO: add the 230 relativ to enum
}

go_upper()
{
    #-- transforms the file into uppercase --#
    tr '[:lower:]' '[:upper:]' < $file_input_tmp > tmp
    cat tmp > $file_input_tmp
    rm tmp
}

get_first_word_of_line()
{
    #-- Gets the first line in the title (Its in the title ¯\_(ツ)_/¯) --#
    ret=$(echo $1 | awk '{print $1;}')
    echo $ret
}

transform()
{
    #-- Removes all the lines that starts with ';' or '|' --#
    grep -v "^\s*[|\;]\|^\s*$" $file_input_tmp > tmp
    echo "{" >> $file_output

    #-- Loops in the tmp file --#
    while read line
    do
        first=$(get_first_word_of_line $line)
        echo "    [$first] =" >> $file_output
        echo "        {" >> $file_output
        #millieu
        echo "        }," >> $file_output
    done < tmp;
    echo "};" >> $file_output
    #-- write it into the file --#
    #TODO: Pas de virgule au dernier
}

################################################################################
#                                 MAIN FUNCTION                                #
################################################################################





#-- Initialisation of the global variables needed used by default--#
path_of_file=`dirname $0`
file_output="$path_of_file/grammar.c"
file_input="$path_of_file/grammar.yacc.example"
file_input_tmp="$path_of_file/grammar.yacc.tmp"

#-- If there's to many parameters or 0, then display help --#
if [ $# = 0 ] || [ $# -ge 5 ]; then
	help
	exit 1;
fi

#-- Parse the options given to the script --#
while getopts ":i:o:h" option
do
	case $option in
		i)
			file_input=$OPTARG
			file_input_tmp=$file_input.tmp
			;;
		o)
			file_output=$OPTARG
			;;
		h)
			help
			exit 1;
			;;
		:)
			echo "the option \"$OPTARG\" requiert an argument"
			exit 1
			;;
		\?)
			echo "\"$OPTARG\" : invalid option"
			exit 1
			;;
	esac
done

#-- Call the init function --#
init

#-- Display a message on the screen --#
echo "\n##################################"
echo "###      GRAMMAR CONVERT       ###"
echo "##################################"
echo "\n\033[4;1minput:\033[0m \"$file_input\"\n\033[4;1moutput:\033[0m \"$file_output\""


#-- Creates a copy of the input to modify it freely --#
cp $file_input $file_input_tmp
parse_info
needed_include=$(parse_includes)
process_grammar
process_numbers
go_upper

#-- Gets the number of grammar symbols (Counts the number of words where their line doesnt start with a '|' or a ';') --#
nb_grammar=$(grep "^[^|;]" $file_input_tmp | wc -l)
transform

#-- Deletes temporary file --#
rm $file_input_tmp
exit 0
