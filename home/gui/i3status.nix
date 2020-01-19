{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
  xdg.configFile."i3status/config".text = ''
    general {
            output_format = "i3bar"
            colors = true
            markup = pango
            interval = 5
            color_good = '${theme.colors.background}'
            color_degraded = '${theme.colors.background}'
            color_bad = '${theme.colors.urgent}'
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
            format = "<span background='${theme.colors.color1}'>  %5min Load </span>"
    }

    disk "/" {
            format = "<span background='${theme.colors.color2}'>  %free Free </span>"
    }

    ethernet _first_ {
            format_up = "<span background='${theme.colors.color3}'>  %ip </span>"
            format_down = ""
    }

    wireless _first_ {
            format_up = "<span background='${theme.colors.color3}'>  %essid </span>"
            format_down = ""
    }

    volume master {
            format = "<span background='${theme.colors.color4}'> 蓼 %volume </span>"
            format_muted = "<span background='${theme.colors.color4}'> 遼 muted </span>"
            device = "default"
            mixer = "Master"
            mixer_idx = 0
    }

    battery all {
            last_full_capacity = true
            integer_battery_capacity = true
            format = "<span background='${theme.colors.color5}'> %status %percentage </span>"
            format_down = ""
            status_chr = ""
            status_bat = ""
            status_unk = ""
            status_full = ""
            path = "/sys/class/power_supply/BAT%d/uevent"
            threshold_type = "percentage"
            low_threshold = 10
    }

    tztime local {
            format = "<span background='${theme.colors.color6}'> %time </span>"
            format_time = " %a %-d %b %H:%M"
    }
  '';
}
