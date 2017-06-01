#!/bin/bash

    #-- Transforms the file into uppercase --#
    tr '[:lower:]' '[:upper:]' < $1 > tmp
    cat tmp > $1
    rm tmp