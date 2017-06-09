#!/bin/bash

output_space()
{
	number_space=`expr 52 - $(echo $name | wc -c)`
	while [ $number_space != 0 ]
	do
		echo -n " " >> $1
		(( number_space-- ))
	done
}

DATE=`date +%Y/%m/%d" "%H:%M:%S`

name=${1##*/}

echo "/* ************************************************************************** */" >> $1
echo "/*                                                                            */" >> $1
echo "/*                                                        :::      ::::::::   */" >> $1
echo -n "/*   " >> $1
echo -n "$name" >> $1
output_space $1
echo ":+:      :+:    :+:   */" >> $1
echo "/*                                                    +:+ +:+         +:+     */" >> $1
echo "/*   By: SSG <SSG@42.fr>                            +#+  +:+       +#+        */" >> $1
echo "/*                                                +#+#+#+#+#+   +#+           */" >> $1
echo "/*   Created: $DATE by SSG               #+#    #+#             */" >> $1
echo "/*   Updated: $DATE by SSG              ###   ########.fr       */" >> $1
echo "/*                                                                            */" >> $1
echo "/* ************************************************************************** */" >> $1
echo "" >> $1
