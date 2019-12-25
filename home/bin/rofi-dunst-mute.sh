#!/usr/bin/env bash

if [ -z $@ ]
then
    echo "mute"
    echo "unmute"
else
    if [[ "$@" == "mute" ]]; then
        notify-send DUNST_COMMAND_PAUSE
    elif [[ "$@" == "unmute" ]]; then
        notify-send DUNST_COMMAND_RESUME
    fi
fi
