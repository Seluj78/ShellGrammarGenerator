#!/bin/bash

$EXEC_PATH/resources/SGG_Header_42.sh $H_OUTPUT

name=$(basename $H_OUTPUT)

name_upper=$(echo $name | tr "a-z" "A-Z" )

touch $H_OUTPUT

echo -n "#ifndef $name_upper" >> $H_OUTPUT
echo "_H" >> $H_OUTPUT
echo -n "# define $name_upper" >> $H_OUTPUT
echo "_H" >> $H_OUTPUT
echo >> $H_OUTPUT



#TODO : make this line optional and modular
echo -e "typedef uint32_t\tt_token_type;" >> $H_OUTPUT



echo >> $H_OUTPUT
echo -e "enum\te_token_type" >> $H_OUTPUT
echo "{" >> $H_OUTPUT
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
	E_TOKEN_MAX" >> $H_OUTPUT
echo "};" >> $H_OUTPUT
echo >> $H_OUTPUT


#TODO : make this line optional and modular
echo -e "typedef	uint32_t\tt_grammar_type;" >> $H_OUTPUT

echo >> $H_OUTPUT
echo -e "enum\te_grammar_type" >> $H_OUTPUT
echo "{" >> $H_OUTPUT
echo -e "\tE_GM_NONE = 200," >> $H_OUTPUT
    count=201
    grep -i ":" $INPUT_TMP | cut -f1 -d":" | tr "a-z" "A-Z" > tmp
    while read line
    do
        echo -e "\tE_""$line"" = $count," >> $H_OUTPUT
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
	echo -e "\tE_GM_END = $count" >> $H_OUTPUT
echo "};" >> $H_OUTPUT

echo $count > count



echo >> $H_OUTPUT
echo "#endif" >> $H_OUTPUT
