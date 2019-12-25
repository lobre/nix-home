#!/usr/bin/env bash

DIR="$HOME/.screenlayout"

if [ -z $@ ]
then
function gen_layouts() {
    for file in $DIR/*
    do
        if [[ -f $file ]]; then
            file="$(basename -- $file)"
            echo "$file" | cut -f 1 -d '.'
        fi
    done
}
gen_layouts

else
    layout="$DIR/$@.sh"
    if [[ -f $layout ]]; then
        sh "$layout"
    fi
fi
