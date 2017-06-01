#!/usr/bin/env bash

output_include()
{
    #-- Prints all the includes --#
	for header in ${needed_includes} ; do
		echo -e "#include <$header>" >> $header_file
	done
}


input_file=$1
needed_includes=$2

#-- Grabs the %includename line --#
grep -i "%filenincludename" $input_file > tmp

#-- Gets just the template (removes everything before the space) --#
name=$(sed 's/[^ ]* //' tmp)
header_file=$("$name"".h")


echo $needed_includes
echo $input_file
echo $header_file