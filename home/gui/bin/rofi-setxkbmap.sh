#!/usr/bin/env bash

if [ -z $@ ]; then
    echo "bepo"
    echo "azerty"
else
    if [[ "$@" == "bepo" ]]; then
        setxkbmap fr -variant bepo
    elif [[ "$@" == "azerty" ]]; then
        setxkbmap fr
    fi
fi
