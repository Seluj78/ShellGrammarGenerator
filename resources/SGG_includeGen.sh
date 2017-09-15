#!/usr/bin/env bash

get_include()
{
    #-- Gets at line $1 the second word (everything after the %include) --#
    var=$(sed ''"$1"'q;d' $2 | awk  '{print $2}')

    #-- echo -e is used to return a value --#
    echo -e $var
}

parse_includes()
{
    #-- Finds the first include line --#
    include_line=$(grep -n "%include" $1 |head -n 1 |cut -d':' -f1)

    #-- Finds the number of includes to process --#
    include_number=$(grep -c "%include" $1)
    count=0
    str=""

    #-- Loops into the %includes and process them then adds them in the str variable --#
    for (( c=$include_line; $count < $include_number; c++ ))
    do
        str="$str $(get_include $c $1)"
        (( count++ ))
    done

    #-- return the str variable --#
    echo -e $str
}

basename $H_OUTPUT > tmp
name=$(cut -f1 -d"." tmp)
rm tmp

needed_include=$(parse_includes $INPUT_TMP)

needed_include="$name.h $needed_include"
#-- Prints all the includes --#
for header in ${needed_include} ; do
  if [[ "$header" != "enum.h" ]]; then
	   echo -e "#include <$header>" >> $C_OUTPUT
  else
    echo -e "#include <parser/$header>" >> $C_OUTPUT
  fi
done
