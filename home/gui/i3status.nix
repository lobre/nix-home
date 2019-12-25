{ config, pkgs, ... }:

{
  xdg.configFile."i3status/config".text = ''

  general {
          output_format = "i3bar"
          colors = true
          markup = pango
          interval = 5
          color_good = '#2f343f'
          color_degraded = '#ebcb8b'
          color_bad = '#ba5e57'
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
          format = "<span background='#f59335'>  %5min Load </span>"
  }

  disk "/" {
          format = "<span background='#fec7cd'>  %free Free </span>"
  }

  ethernet _first_ {
          format_up = "<span background='#88c0d0'>  %ip </span>"
          format_down = ""
  }

  wireless _first_ {
          format_up = "<span background='#b48ead'>  %essid </span>"
          format_down = ""
  }

  volume master {
          format = "<span background='#ebcb8b'> 蓼 %volume </span>"
          format_muted = "<span background='#ebcb8b'> 遼 muted </span>"
          device = "default"
          mixer = "Master"
          mixer_idx = 0
  }

  battery all {
          last_full_capacity = true
          integer_battery_capacity = true
          format = "<span background='#a3be8c'> %status %percentage </span>"
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
          format = "<span background='#81a1c1'> %time </span>"
          format_time = " %a %-d %b %H:%M"
  }

  '';
}
