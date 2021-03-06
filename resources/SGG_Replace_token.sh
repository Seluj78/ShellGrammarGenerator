#!/bin/bash


  nb_line=1
  line_string=$(sed $nb_line!d $INPUT)
  grep -i "%tokentemplate" $INPUT > tmp2

  #-- Gets just the template (removes everything before the space) --#
  template=$(sed 's/[^ ]* //' tmp2)
  rm tmp2

while [[ $(echo -e $line_string | awk '{print $1;}') = "%token" ]]; do
  #-- Gets the line string with variable --#
  line_string=$(sed $nb_line!d $INPUT)

  #-- Gets the number of words in line --#
  number_of_word=$(echo -e $line_string | wc -w)
  number_of_word=$(echo -e $number_of_word | tr -d ' ')

  old=$(echo $line_string | sed 's/.*://')
  new=${line_string%:*}
  new=$(echo $new| tr -d '%token ')
  for word in $old
  do
    if [[ $word != "," ]]; then
      sed -i.bak "s/$(echo "'$word'")/$(echo "$new")/g" "$C_OUTPUT"
    fi
    (( number_of_word-- ))
  done

    (( nb_line++ ))
done

nb_line=1
line_string=$(sed $nb_line!d $INPUT)
while [[ $(echo -e $line_string | awk '{print $1;}') = "%token" ]]; do
  #-- Gets the line string with variable --#
  line_string=$(sed $nb_line!d $INPUT)

  new=${line_string%:*}
  new=$(echo $new| tr -d '%token ')
  if [[ -n $new ]]; then
  old="E_GRAM_$new"
  new="$template$new"
  sed -i.bak "s/{$old, /{$new, /g" $C_OUTPUT
  sed -i.bak "s/, $old, /, $new, /g" $C_OUTPUT
  sed -i.bak "s/, $old}/, $new}/g" $C_OUTPUT
  sed -i.bak "s/{$old}/{$new}/g" $C_OUTPUT

rm $C_OUTPUT.bak

fi
    (( nb_line++ ))
done
