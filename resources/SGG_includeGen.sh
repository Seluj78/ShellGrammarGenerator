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

file_name="$3/enum.h"

#-- Grabs the %tokentemplate line --#
name=$(grep -i "%fileincludename" $4 | sed 's/[^ ]* //')

if [ -z "$name" ]; then
    echo "No %fileincludename provided. Going for enum.h"
else
    file_name="$name.h"
fi #TODO: add theses lines to includeGen !


needed_include=$(parse_includes $2)

needed_include="$name.h $needed_include"
#-- Prints all the includes --#
for header in ${needed_include} ; do
	echo -e "#include <$header>" >> $1
done
