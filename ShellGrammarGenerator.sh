#!/bin/bash

#-- Gets where the shell script is --#
export EXEC_PATH=`dirname $0`
#-- Sets the default output --#
export C_OUTPUT="$EXEC_PATH/grammar.c"
export H_OUTPUT="$EXEC_PATH/enum.h"
export INPUT_TMP="$EXEC_PATH/examples/grammar.yacc.tmp"
#-- Sets the default input --#
export INPUT="$EXEC_PATH/examples/grammar.yacc.example"

#-- If there's to many parameters or 0, then display help --#
if [ $# = 0 ] || [ $# -ge 7 ]; then
	$EXEC_PATH/resources/SGG_help.sh
	exit 1;
fi

#-- This module converts the long arguments into shorter ones for getopt --#
for arg in "$@"; do
  shift
  case "$arg" in
    "--help") set -- "$@" "-h" ;;
    "--input") set -- "$@" "-i" ;;
    "--output")   set -- "$@" "-o" ;;
    *)        set -- "$@" "$arg" ;;
  esac
done


#-- Parses the options given to the script --#
while getopts ":i:o:hH:" option
do
	case $option in
		i)
			export INPUT="$OPTARG"
			;;
		o)
			export C_OUTPUT="$OPTARG"
			;;
		H)
		    export H_OUTPUT="$OPTARG"
		    ;;
		h)
			$EXEC_PATH/resources/SGG_help.sh
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

$EXEC_PATH/resources/SGG_init.sh
if [ $? != 0 ]; then
	exit 1
fi

cp $INPUT $INPUT_TMP
sed -i.bak '/^#/d' $INPUT_TMP
rm $INPUT_TMP.bak
cut -d'#' -f1 $INPUT_TMP > tmpcomment
cat tmpcomment > $INPUT_TMP
rm tmpcomment

#-- Displays the startup message on the screen --#
echo -e "\n##################################"
echo -e "###   SHELL GRAMMAR GENERATOR  ###"
echo -e "##################################"
echo -e -n "\n\033[4;1minput:\033[0m \"$(basename $INPUT)\"\n\033[4;1moutput:\033[0m \"$(basename $C_OUTPUT)\" && \"$(basename $H_OUTPUT)\""

echo -e "\n"
$EXEC_PATH/resources/SGG_Parser.sh
if [[ $? != 0 ]]; then
	exit 1
fi
$EXEC_PATH/resources/SGG_HeaderFileGen.sh
$EXEC_PATH/resources/SGG_tokenhandler.sh
$EXEC_PATH/resources/SGG_includeGen.sh
$EXEC_PATH/resources/SGG_RemoveInfo.sh
$EXEC_PATH/resources/SGG_ProcessNumbers.sh
$EXEC_PATH/resources/SGG_GoUpperCase.sh
$EXEC_PATH/resources/SGG_Output3DArray.sh
$EXEC_PATH/resources/SGG_Replace_token.sh

rm tmptokens
rm count
rm $INPUT_TMP
exit 0
