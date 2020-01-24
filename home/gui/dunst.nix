{ config, pkgs, ... }:

let
  theme = config.theme;
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
        font = "${theme.font} 10";
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
        separator_height = 0;
        padding = 8;
        horizontal_padding = 8;
        separator_color = "auto";
        startup_notification = false;
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst:";
        browser = "xdg-open";
        icon_position = "left";
        max_icon_size = 32;
        stack_duplicates = false;
        hide_duplicate_count = true;
      };

      frame = {
        width = 2;
        color = "${theme.colors.background}";
      };

      shortcuts = {
        close = "mod4+d";
      };

      urgency_low = {
        timeout = 2;
        background = "${theme.colors.background}";
        foreground = "${theme.colors.foreground}";
      };

      urgency_normal = {
        timeout = 4;
        background = "${theme.colors.background}";
        foreground = "${theme.colors.foreground}";
      };

      urgency_critical = {
        timeout = 0;
        background = "${theme.colors.urgent}";
        foreground = "${theme.colors.background}";
        frame_color = "${theme.colors.urgent}";
      };
    };
  };
}
