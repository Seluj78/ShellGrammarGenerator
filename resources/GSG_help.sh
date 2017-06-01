#!/bin/bash

echo -e "\nUsage:  ./ShellGrammarConverter.sh [input_file] [desired_output_file.h]"
echo -e "\t\033[1;mExample: ./ShellGrammarConverter.sh -i grammar.file -o grammar.h\033[0m"
echo -e
echo -e "\t\033[1m-i --input\033[0m  (required), used to specify the grammar file (in yacc format). If not set, will display an error"
echo -e "\t\033[1m-o --output\033[0m (optional), if not set, grammar_converter will output into grammar.c and grammar.h files"
echo -e "\t\033[1m-h --help\033[0m   (help) Will display help"