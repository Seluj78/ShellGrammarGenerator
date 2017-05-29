#!/bin/bash

################################################################################
#                              BASES FUNCTIONS                                 #
################################################################################

help()
{
	echo -e "\nUsage:  ./grammar_converter.sh [input_file] [desired_output_file.h]"
	echo -e "\t\033[1;mExample: ./grammar_converter.sh -i grammar.file -o grammar.h\033[0m"
	echo
	echo -e "\t\033[1m-i --input\033[0m  (required), used to specify the grammar file (in yacc format). If not set, will display an error"
	echo -e "\t\033[1m-o --output\033[0m (optional), if not set, grammar_converter will output into grammar.c and grammar.h files"
	echo -e "\t\033[1m-h --help\033[0m   (help) Will display help"
} 

init()
{
	if [ ! -f $file_input ]; then
		echo "File \"$file_input\" not found!"
		exit 1
	fi
	touch $file_output
}

################################################################################
################################################################################


################################################################################
#                              INFO TOKEN FUNCTION                             #
################################################################################

rm_info()
{
	sed -i.bak '/^%/d' $1
	rm $1.bak
	sed -i.bak '/^$/d' $1
	rm $1.bak
}

replace_info()
{
	start=$(awk '/%%/{ print NR; exit }' $file_input_tmp)
	(( start++ ))
	count=0
	line=$(sed ''"$1"'!d' $file_input_tmp)
	for word in $line
	do
		if [ $count = 1 ]; then
			old=$word
		elif [ $count = 2 ]; then
			new=$word
		fi
		(( count++ ))
	done
	sed -i.bak ''"$start"',$s,'"$old"','"$new"',' "$file_input_tmp"
	rm $file_input_tmp.bak
}

parse_info()
{
	token_number=$(grep -c "%token" $file_input_tmp)
	#token_number = number of tokens to parse and replace

	n=1
	while [ $n -le $token_number ]
	do
		replace_info $n
		(( n++ ))
	done
	rm_info $file_input_tmp
}
################################################################################
################################################################################


#TODO : relative path

path_of_file=`dirname $0`
file_output="$path_of_file/grammar.c"
file_input="$path_of_file/grammar.yacc"
file_input_tmp="$path_of_file/grammar.yacc.tmp"

if [ $# = 0 ] || [ $# -ge 5 ]; then
	help
	exit 1;
fi

while getopts ":i:o:h" option
do
	case $option in
		i)
			#check_path
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
			echo -e "the option \"$OPTARG\" requiert an argument"
			exit 1
			;;
		\?)
			echo -e "\"$OPTARG\" : invalid option"
			exit 1
			;;
	esac
done
init
echo -e "\n##################################"
echo -e "###      GRAMMAR CONVERT       ###"
echo -e "##################################"
echo -e "\n\033[4;1minput:\033[0m \"$file_input\"\n\033[4;1moutput:\033[0m \"$file_output\""

touch $file_input_tmp
cp $file_input $file_input_tmp
parse_info
rm $file_input_tmp
exit 0
