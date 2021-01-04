#!/usr/bin/env bash

dir=$(realpath $(dirname "$0"))
if grep '^NAME' /etc/os-release | grep NixOS >/dev/null; then
    dir=$dir/machines/$(hostname)
fi

mode=$1

function switch_home() {
    conf="$dir/home.nix"
    if [ ! -f "$conf" ]; then
        echo "error: $conf does not exist."
        exit 1
    fi

    echo "switching home configuration from..."
    echo "using: $conf"
    exec home-manager switch -f "$conf" -b bak "$@"
}

function switch_system() {
    if [[ $(whoami) != "root" ]]; then
        echo "error: use sudo to switch system configuration"
        exit 1
    fi

    conf="$dir/configuration.nix"
    if [ ! -f "$conf" ]; then
        echo "error: $conf does not exist."
        exit 1
    fi

    echo "switching system configuration..."
    echo "using: $conf"
    exec env NIXOS_CONFIG="$conf" nixos-rebuild switch "$@"
}


case "$mode" in
"home")
    switch_home "${@:2}"
    ;;
"system")
    switch_system "${@:2}"
    ;;
*)
    echo "error: first parameter should be home or system"
    ;;
esac

