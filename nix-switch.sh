#!/usr/bin/env bash

dir=$(realpath $(dirname "$0"))
mode=$1

function switch_home() {
    conf="$dir/home.nix"
    if [ ! -f "$conf" ]; then
        echo "error: $conf does not exist."
        exit 1
    fi

    echo "switching home configuration..."
    exec home-manager switch -f "$conf" -b bak
}

function switch_system() {
    if [[ $(whoami) != "root" ]]; then
        echo "error: use sudo to switch system configuration"
        exit 1
    fi

    conf="$dir/system.nix"
    if [ ! -f "$conf" ]; then
        echo "error: $conf does not exist."
        exit 1
    fi

    echo "switching system configuration..."
    exec env NIXOS_CONFIG="$conf" nixos-rebuild switch
}

case "$mode" in
"home")
    switch_home
    ;;
"system")
    switch_system
    ;;
*)
    echo "error: first parameter should be home or system"
    ;;
esac

