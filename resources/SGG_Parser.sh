#!/bin/bash

################################################################################
#                                 PARSE %                                      #
################################################################################

percent_token()
{
	local line
	local line_number=1

	line_number=$(echo -e $line_number | tr -d ' ')
	line=$(sed $line_number!d $file_to_parse)
	if [ "${line:0:7}" != "%token" ] && [ "${line:0:7}" != "%token " ]; then
		echo "PARSER: (line=$line_number) expected '%token' (at the beginning of file)"
		exit 1
	fi

	while read line
	do
		if [ "${line:0:7}" != "%token" ] && [ "${line:0:7}" != "%token "  ]; then
			break
		#elif [ $(echo "$line" | wc -w) -ne 2 ]; then
			#echo "PARSER: (line=$line_parse) expected only one word after %token"
			#exit 1
		fi
		(( line_parse++ ))
	done < $file_to_parse;

	if [ "$(sed $line_parse!d $file_to_parse)" !=  "" ]; then
		echo "PARSER: (line=$line_parse) expected  \n"
		exit 1
	fi
	(( line_parse++ ))
}

percent_template()
{
	local line
	line=$(sed $line_parse!d $file_to_parse)
	if [ "${line:0:15}" != "%tokentemplate" ] && [ "${line:0:15}" != "%tokentemplate " ]; then
		echo "PARSER: (line=$line_parse) expected '%tokentemplate'"
		exit 1
	fi

	if [ $(echo "$line" | wc -w) -ne 2 ]; then
		echo "PARSER: (line=$line_parse) expected one word after %tokentemplate"
		exit 1
	fi
	(( line_parse++ ))

	line=$(sed $line_parse!d $file_to_parse)
	if [ "$line" != "" ]; then
		echo "PARSER: (line=$line_parse) expected \n "
		exit 1
	fi
	(( line_parse++ ))
}

percent_include()
{
	local line

	line_parser=$(echo -e $line_parse | tr -d ' ')
	line=$(sed $line_parse!d $file_to_parse)

	if [ "${line:0:8}" != "%include" ] && [ "${line:0:9}" != "%include " ]; then
		echo "PARSER: (line=$line_parse) expected '%include'"
		exit 1
	fi

	while [ "${line:0:8}" = "%include" ] || [ "${line:0:9}" = "%include "  ]
	do
		if [ $(echo "$line" | wc -w) -gt 2 ]; then
			echo "PARSER: (line=$line_parse) too many words after %include"
			exit 1
		fi
		(( line_parse++ ))
		line_parser=$(echo -e $line_parse | tr -d ' ')
		line=$(sed $line_parse!d $file_to_parse)
	done

	if [ "$(sed $line_parse!d $file_to_parse)" !=  "" ]; then
		echo "PARSER: (line=$line_parse) expected  \n "
		exit 1
	fi
	(( line_parse++ ))
}

percent_fileincludename()
{
	local line
	line=$(sed $line_parse!d $file_to_parse)

	if [ ! $(echo "$line" | wc -w) -eq 2 ]; then
		echo "PARSER: (line=$line_parse) expected only one word after %fileincludename"
		exit 1
	fi
	(( line_parse++ ))

	line=$(sed $line_parse!d $file_to_parse)
	if [ "$line" != "" ]; then
		echo "PARSER: (line=$line_parse) expected \n "
		exit 1
	fi
	(( line_parse++ ))
}

percent_percent()
{
	local line
	line=$(sed $line_parse!d $file_to_parse)

	if [ "${line:0:6}" != "%start" ] && [ "${line:0:7}" != "%start " ]; then
		echo "PARSER: (line=$line_parse) expected '%start'"
		exit 1
	fi

	if [ $(echo "$line" | wc -w) -gt 2 ]; then
		echo "PARSER: (line=$line_parse) too many words after %start"
		exit 1
	fi
	(( line_parse++ ))

	line=$(sed $line_parse!d $file_to_parse)
	if [ "$line" != "" ]; then
		echo "PARSER: (line=$line_parse) expected \n "
		exit 1
	fi
	(( line_parse++ ))

	line=$(sed $line_parse!d $file_to_parse)
	if [ "${line:0:2}" != "%%" ] && [ "${line:0:2}" != "%% " ]; then
		echo "PARSER: (line=$line_parse) expected '%%'"
		exit 1
	fi
	(( line_parse++ ))

	line=$(sed $line_parse!d $file_to_parse)
	if [ "$line" != "" ]; then
		echo "PARSER: (line=$line_parse) expected \n "
		exit 1
	fi
	(( line_parse++ ))

}

parse_process_percent()
{
	line=$(sed $line_parse!d $file_to_parse)
	if [ "${line:0:7}" = "%token" ] || [ "${line:0:7}" = "%token " ]; then
		percent_token
		percent_template
	elif [ "${line:0:15}" = "%tokentemplate" ] || [ "${line:0:15}" = "%tokentemplate " ]; then
		echo "PARSER: (line=$line_parse) not expected without '%token'"
		exit 1
	fi
	line=$(sed $line_parse!d $file_to_parse)
	if [ "${line:0:16}" = "%fileincludename" ] || [ "${line:0:17}" = "%fileincludename " ]; then
		percent_fileincludename
	fi
	percent_include
	percent_percent
}

################################################################################
################################################################################


################################################################################
#                            INIT END AND START                                #
################################################################################

no_white_space()
{
	local line
	local line_number=$(cat $file_to_parse | wc -l)

	line_number=$(echo -e $line_number | tr -d ' ')

	while [ $line_number -ne 0 ]
	do
		line=$(sed $line_number!d $file_to_parse)
		if [ "${line:0:1}" = " " ] || [ "${line:0:1}" = "	" ]; then
			echo "PARSER: (line=$line_number) unexpected space or tabulation"
			exit 1
		fi
		(( line_number-- ))
	done
	line_number=1
	line=$(sed $line_number!d $file_to_parse)
	if [ $(echo "$line" | wc -w) -eq 0 ]; then
		echo "PARSER: (line=$line_number) expected word(s)"
		exit 1
	fi
}

semili_at_the_end()
{
	local line
	local line_number=$(cat $file_to_parse | wc -l)

	line_number=$(echo -e $line_number | tr -d ' ')
	line=$(sed $line_number!d $file_to_parse)
	if [ "$line" != ";" ]; then
		(( line_number++ ))
		line_number=$(echo -e $line_number | tr -d ' ')
		line=$(sed $line_number!d $file_to_parse)
		if [ "$line" != ";" ]; then
			echo "PARSER: (line=$line_number) expected ';' (at the end of file)"
			exit 1
		fi
	fi
}

################################################################################
################################################################################

################################################################################
#                              process_parse                                   #
################################################################################

process_parse()
{
	no_white_space
	semili_at_the_end
	parse_process_percent
}
################################################################################
################################################################################


################################################################################
#                            VARIABLE GLOBALS                                  #
################################################################################

file_to_parse=$INPUT
line_parse=1

################################################################################
################################################################################


if test $(echo $file_to_parse |awk -F . '{if (NF>1) {print $NF}}') != "yacc"; then
	echo -e "\033[1;31;4mWARNING:\033[0m \033[1mIt is not a .yacc\033[0m"
fi

if [ ! -f $file_to_parse ]; then
	echo "\033[1;31m $file_to_parse doesn't exist\033[0m"
	exit 1
fi

process_parse
echo "PARSER: OK"
exit 0
