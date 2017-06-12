#!/bin/bash

    #-- Transforms the file into uppercase --#
    tr '[:lower:]' '[:upper:]' < $INPUT_TMP > tmp
    cat tmp > $INPUT_TMP
    rm tmp