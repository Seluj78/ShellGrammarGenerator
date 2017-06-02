#!/bin/bash

################################################################################
#                            ShellGrammarConverter                             #
################################################################################


#-- Initialisation of the global variables needed used by default--#
path_of_file=`dirname $0`
file_output="$path_of_file/grammar.c"
file_input="$path_of_file/example/grammar.yacc.example"
file_input_tmp="$path_of_file/example/grammar.yacc.tmp"
#------------------------------------------------------------------#


#-- If there's to many parameters or 0, then display help --#
if [ $# = 0 ] || [ $# -ge 5 ]; then
	$path_of_file/resources/SGG_help.sh
	exit 1;
fi
#-----------------------------------------------------------#


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
#--------------------------------------------------------------------------#



#-- Parses the options given to the script --#
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
			$path_of_file/resources/SGG_help.sh
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
#--------------------------------------------#


#-- Calls the init function --#
$path_of_file/resources/SGG_init.sh $file_input $file_output $path_of_file
if [ $? != 0 ]; then
	exit 1
fi
#-----------------------------#

#-- Creates a copy of the input to modify it freely --#
cp $file_input $file_input_tmp
sed -i.bak '/^#/d' $file_input_tmp
rm $file_input_tmp.bak
cut -d'#' -f1 $file_input_tmp > tmpcomment
cat tmpcomment > $file_input_tmp
rm tmpcomment
#-----------------------------------------------------#

#-- Parse file input --#
$path_of_file/resources/SGG_Parser.sh $file_input_tmp
if [ $? != 0 ]; then
	rm $file_output
	exit 1
fi
#----------------------#

#-- Displays the startup message on the screen --#
echo -e "\n##################################"
echo -e "###   SHELL GRAMMAR GENERATOR  ###"
echo -e "##################################"
echo -e "\n\033[4;1minput:\033[0m \"$file_input\"\n\033[4;1moutput:\033[0m \"$file_output\""
#------------------------------------------------#

$path_of_file/resources/SGG_HeaderFileGen.sh $path_of_file $file_input_tmp $file_output $file_input
$path_of_file/resources/SGG_Header_42.sh $file_output
$path_of_file/resources/SGG_tokenhandler.sh $file_input_tmp
$path_of_file/resources/SGG_includeGen.sh $file_output $file_input_tmp $path_of_file $file_input
$path_of_file/resources/SGG_RemoveInfo.sh $file_input_tmp
$path_of_file/resources/SGG_ProcessNumbers.sh $file_input_tmp $file_output
$path_of_file/resources/SGG_GoUpperCase.sh $file_input_tmp
$path_of_file/resources/SGG_Output3DArray.sh $file_input_tmp $file_output
#---------#

#-- Deletes temporary files --#
rm tmptokens
rm $file_input_tmp
rm count
#-----------------------------#


exit 0


#TODO :make vars local if needed
#TODO :Add comments handling
#TODO: Obligatoire: si %fileincludename est la, alors doit avoir 1 word apres. sinon, il ne doit pas etre la et nom fichier.h par default
