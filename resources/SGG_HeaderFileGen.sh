#!/bin/bash

path_of_file=$1
file_input_tmp=$2
file_output=$3
file_input=$4

file_name="$path_of_file/enum.h"
$path_of_file/resources/SGG_Header_42.sh $file_name

#-- Grabs the %tokentemplate line --#
name=$(grep -i "%fileincludename" $file_input | sed 's/[^ ]* //')

if [ -f "$name" ]; then
    file_name="$name.h"
fi #TODO: add theses lines to includeGen !
echo -e "\n\033[4;1moutput header:\033[0m \"$(basename $file_name)\"\n"

name_upper=$(echo $name | tr "a-z" "A-Z" )

touch $file_name

echo -n "#ifndef $name_upper" >> $file_name
echo "_H" >> $file_name
echo -n "# define $name_upper" >> $file_name
echo "_H" >> $file_name
echo >> $file_name



#TODO : make this line optional and modular
echo -e "typedef uint32_t\tt_token_type;" >> $file_name



echo >> $file_name
echo -e "enum\te_token_type" >> $file_name
echo "{" >> $file_name
echo -e "\tE_TOKEN_NONE,
	E_TOKEN_BLANK,
	E_TOKEN_NEWLINE,
	E_TOKEN_WORD,
	E_TOKEN_SQUOTE,
	E_TOKEN_BQUOTE,
	E_TOKEN_DQUOTE,
	E_TOKEN_PIPE,
	E_TOKEN_LESSGREAT,
	E_TOKEN_AND,
	E_TOKEN_SEMI,
	E_TOKEN_IO_NUMBER,
	E_TOKEN_DLESS,
	E_TOKEN_DGREAT,
	E_TOKEN_OR_IF,
	E_TOKEN_AND_IF,
	E_TOKEN_LESSAND,
	E_TOKEN_GREATAND,
	E_TOKEN_MAX" >> $file_name
echo "};" >> $file_name
echo >> $file_name


#TODO : make this line optional and modular
echo -e "typedef	uint32_t\tt_grammar_type;" >> $file_name

echo >> $file_name
echo -e "enum\te_grammar_type" >> $file_name
echo "{" >> $file_name
echo -e "\tE_GM_NONE = 200," >> $file_name
    count=201
    grep -i ":" $file_input_tmp | cut -f1 -d":" | tr "a-z" "A-Z" > tmp
    while read line
    do
        echo -e "\tE_""$line"" = $count," >> $file_name
        (( count++ ))
    done < tmp
    rm tmp
	#E_GM_NONE = 200,
	#E_PROGRAM = 201,
	#E_COMPLETE_COMMANDS = 202,
	#E_COMPLETE_COMMAND = 203,
	#E_LIST = 204,
	#E_AND_OR = 205,
	#E_PIPELINE = 206,
	#E_PIPE_SEQUENCE = 207,
	#E_COMMAND = 208,
	#E_SIMPLE_COMMAND = 209,
	#E_CMD_NAME = 210,
	#E_CMD_WORD = 211,
	#E_CMD_PREFIX = 212,
	#E_CMD_SUFFIX = 213,
	#E_IO_REDIRECT = 214,
	#E_IO_FILE = 215,
	#E_FILENAME = 216,
	#E_IO_HERE = 217,
	#E_HERE_END = 218,
	#E_NEWLINE_LIST = 219,
	#E_LINEBREAK = 220,
	#E_SEPARATOR_OP = 221,
	#E_SEPARATOR = 222,
	#E_SEQUENTIAL_SEP = 223,
	#
	echo -e "\tE_GM_END = $count" >> $file_name
echo "};" >> $file_name

echo $count > count



echo >> $file_name
echo "#endif" >> $file_name
