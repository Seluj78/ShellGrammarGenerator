#!/bin/bash

    #-- Removes every line that starts with a % (info) --#
	sed -i.bak '/^%/d' $1
	rm $1.bak
	#-- Removes every blank line/line filled with whitespaces --#
	sed -i.bak '/^$/d' $1
	rm $1.bak