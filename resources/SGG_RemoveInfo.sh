#!/bin/bash

    #-- Removes every line that starts with a % (info) --#
	sed -i.bak '/^%/d' $INPUT_TMP
	#-- Removes every blank line/line filled with whitespaces --#
	sed -i.bak '/^$/d' $INPUT_TMP
    rm $INPUT_TMP.bak
