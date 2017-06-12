#!/bin/bash

add_template()
{
    new="$2""$1"
    echo -e $new
}

#-- Grabs the %tokentemplate line --#
grep -i "%tokentemplate" $INPUT_TMP > tmp

#-- Gets just the template (removes everything before the space) --#
template=$(sed 's/[^ ]* //' tmp)

#-- Grabs only the tokens --#
grep -i "%token " $INPUT_TMP | sed -e "s/^%token  //" > tmptokens

count=1
while read line
do
#-- Grabs the token at the $count line --#
token=$(sed ''"$count"'!d' tmptokens)

#-- Adds the template --#
token_templated=$(add_template $token $template)
#-- Does the replacement --#
sed -i.bak 's/'"$token"'/'"$token_templated"'/g' $INPUT_TMP
(( count++ ))
done < tmptokens
touch $1.bak
rm $1.bak