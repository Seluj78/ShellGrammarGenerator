#!/bin/sh

################################################################################
#                              BASES FUNCTIONS                                 #
################################################################################

help()
{
	echo "\nUsage:  ./grammar_converter.sh [input_file] [desired_output_file.h]"
	echo "\t\033[1;mExample: ./grammar_converter.sh -i grammar.file -o grammar.h\033[0m"
	echo
	echo "\t\033[1m-i --input\033[0m  (required), used to specify the grammar file (in yacc format). If not set, will display an error"
	echo "\t\033[1m-o --output\033[0m (optional), if not set, grammar_converter will output into grammar.c and grammar.h files"
	echo "\t\033[1m-h --help\033[0m   (help) Will display help"
}

init()
{
	if [ ! -f $file_input ]; then
		echo "File \"$file_input\" not found!"
		exit 1
	elif [[  -f $file_output  ]]; then
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
new="$2""$old"
    sed -i.bak ''"$start"',$s,'"$old"','"$new"',' "$file_input_tmp"
	rm $file_input_tmp.bak
}

parse_info()
{
	token_number=$(grep -c "%token" $file_input_tmp)
    grep -i "%tokentemplate" $file_input_tmp > tmp
    template=$(sed 's/[^ ]* //' tmp)
	n=1
	while [ $n -le $token_number ]
	do
		replace_info $n $template
		(( n++ ))
	done
	rm tmp
}

get_include()
{
    var=$(sed ''"$1"'q;d' $file_input_tmp | awk  '{print $2}')
    echo $var
}

parse_includes()
{
    include_line=$(grep -n "%include" $file_input_tmp |head -n 1 |cut -d':' -f1)
    include_number=$(grep -c "%include" $file_input_tmp)
    count=0
    str=""
    for (( c=$include_line; $count < $include_number; c++ ))
    do
        str="$str $(get_include $c)"
        (( count++ ))
    done
    echo $str
}

################################################################################
#                              GENERATOR OUTPUT                                #
################################################################################

output_include()
{
	for file in ${needed_include} ; do
		echo "#include <$file>" >> $file_output
	done
}

output_tab()
{
    name_start=$(awk '{for (I=1;I<=NF;I++) if ($I == "%start") {print $(I+1)};}' $file_input_tmp)
}


process_grammar()
{
	output_include
	output_tab
	rm_info $file_input_tmp
}

process_numbers()
{
    actual=0
    max_pipe=0
    max_comma=0
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

cat $file_input_tmp > tmp

cut -d':' -f2 tmp > tmp1
cut -c 2- tmp1 > tmp2

    while read line_2
    do
        actual=$(echo $line_2 | wc -w)
        if [ $max_comma -lt $actual ]; then
            max_comma=${actual}
        fi
        actual=0
    done < tmp2;

rm tmp tmp1 tmp2

max_comma=$(echo $max_comma | tr -d ' ')

    max_pipe=$(($max_pipe + 1))
    echo "\nuint32_t    grammar[][$max_pipe][$max_comma]=" >> $file_output
    #TODO: add the 230 relativ to enum
}

go_upper()
{
    tr '[:lower:]' '[:upper:]' < $file_input_tmp > tmp
    cat tmp > $file_input_tmp
    rm tmp
}

get_first_word_of_line()
{
    ret=$(echo $1 | awk '{print $1;}')
    echo $ret
}

transform()
{
    grep -v "^\s*[|\;]\|^\s*$" $file_input_tmp > tmp
    echo "{" >> $file_output
    while read line
    do
        first=$(get_first_word_of_line $line)
        echo "    [$first] =" >> $file_output
        echo "        {" >> $file_output
        #millieu
        echo "        }," >> $file_output
    done < tmp;
    echo "};" >> $file_output
    #TODO: Pas de virgule au dernier
}

################################################################################
#                                 MAIN FUNCTION                                #
################################################################################

path_of_file=`dirname $0`
file_output="$path_of_file/grammar.c"
file_input="$path_of_file/grammar.yacc.example"
file_input_tmp="$path_of_file/grammar.yacc.tmp"

if [ $# = 0 ] || [ $# -ge 5 ]; then
	help
	exit 1;
fi

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
init
echo "\n##################################"
echo "###      GRAMMAR CONVERT       ###"
echo "##################################"
echo "\n\033[4;1minput:\033[0m \"$file_input\"\n\033[4;1moutput:\033[0m \"$file_output\""

cp $file_input $file_input_tmp
parse_info
needed_include=$(parse_includes)
process_grammar
process_numbers
go_upper
nb_grammar=$(grep "^[^|;]" $file_input_tmp | wc -l)
transform
rm $file_input_tmp
exit 0
