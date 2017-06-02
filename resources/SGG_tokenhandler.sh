#!/bin/bash

add_template()
{
    new="$2""$1"
    echo -e $new
}

#-- Grabs the %tokentemplate line --#
grep -i "%tokentemplate" $1 > tmp

#-- Gets just the template (removes everything before the space) --#
template=$(sed 's/[^ ]* //' tmp)

#-- Grabs only the tokens --#
grep -i "%token " $1 | sed -e "s/^%token  //" > tmptokens

count=1
while read line
do
#-- Grabs the token at the $count line --#
token=$(sed ''"$count"'!d' tmptokens)

#-- Adds the template --#
token_templated=$(add_template $token $template)

#-- Does the replacement --#
sed -i.bak 's/'"$token"'/'"$token_templated"'/g' $1
(( count++ ))
done < tmptokens
touch $1.bak
rm $1.bak
