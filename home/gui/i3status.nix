{ config, pkgs, ... }:

let
  colors = import ./colors.nix;
in

{
  xdg.configFile."i3status/config".text = ''
    general {
            output_format = "i3bar"
            colors = true
            markup = pango
            interval = 5
            color_good = '${colors.gray-800}'
            color_degraded = '${colors.gray-800}'
            color_bad = '${colors.red-800}'
            separator = ""
    }

    order += "load"
    order += "disk /"
    order += "ethernet _first_"
    order += "wireless _first_"
    order += "volume master"
    order += "battery all"
    order += "tztime local"

    load {
            format = "<span background='${colors.red-600}'> ☢ %1min Load </span>"
    }

    disk "/" {
            format = "<span background='${colors.green-400}'> ☉ %free Free </span>"
    }

    ethernet _first_ {
            format_up = "<span background='${colors.yellow-300}'> ⇵ %ip </span>"
            format_down = ""
    }

    wireless _first_ {
            format_up = "<span background='${colors.yellow-300}'> ⇵ %essid </span>"
            format_down = ""
    }

    volume master {
            format = "<span background='${colors.blue-300}'> ♩ %volume </span>"
            format_muted = "<span background='${colors.blue-300}'> ♩ muted </span>"
            device = "default"
            mixer = "Master"
            mixer_idx = 0
    }

    battery all {
            last_full_capacity = true
            integer_battery_capacity = true
            format = "<span background='${colors.purple-300}'> ⌁ %percentage </span>"
            format_down = ""
            path = "/sys/class/power_supply/BAT%d/uevent"
            threshold_type = "percentage"
            low_threshold = 10
    }

    tztime local {
            format = "<span background='${colors.teal-300}'> %time </span>"
            format_time = "☀ %a %-d %b %H:%M"
    }
  '';
}
