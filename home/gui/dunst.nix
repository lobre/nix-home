{ config, pkgs, ... }:

let
  colors = import ./colors.nix;
in

{
  services.dunst = {
    enable = true;

    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };

    settings = {
      global = {
        font = "monospace 10";
        allow_markup = true;
        format = " <b>%s</b>\n%b";
        sort = true;
        indicate_hidden = true;
        alignment = "left";
        bounce_freq = 0;
        show_age_threshold = 60;
        word_wrap = true;
        ignore_newline = false;
        geometry = "300x5-5+35";
        shrink = true;
        transparency = 5;
        idle_threshold = 120;
        monitor = 0;
        follow = "mouse";
        sticky_history = true;
        history_length = 20;
        show_indicators = false;
        line_height = 4;
        separator_height = 1;
        padding = 8;
        horizontal_padding = 8;
        separator_color = "${colors.gray-700}";
        startup_notification = false;
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst:";
        browser = "xdg-open";
        icon_position = "left";
        max_icon_size = 32;
        stack_duplicates = false;
        hide_duplicate_count = true;
      };

      frame = {
        width = 1;
        color = "${colors.gray-700}";
      };

      shortcuts = {
        close = "mod4+d";
      };

      urgency_low = {
        timeout = 4;
        background = "${colors.gray-800}";
        foreground = "${colors.gray-100}";
      };

      urgency_normal = {
        timeout = 4;
        background = "${colors.gray-800}";
        foreground = "${colors.gray-100}";
      };

      urgency_critical = {
        timeout = 0;
        background = "${colors.red-800}";
        foreground = "${colors.gray-100}";
        frame_color = "${colors.red-800}";
      };
    };
  };
}
