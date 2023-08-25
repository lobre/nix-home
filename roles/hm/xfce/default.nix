{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    calibre
    chrysalis
    discord
    filezilla
    firefox
    libnotify
    libreoffice
    meld
    nitrogen
    pavucontrol
    pinta
    qtpass
    remmina
    spotify
    sqlitebrowser
    vlc
    xdotool
    xsel

    # font
    (iosevka-bin.override { variant = "sgr-iosevka-term-slab"; })
  ];

  programs = {
    browserpass.enable = true;

    feh = {
      enable = true;
      keybindings = {
        zoom_in = "plus";
        zoom_out = "minus";
        scroll_left = "h";
        scroll_right = "l";
        scroll_up = "k";
        scroll_down = "j";
      };
    };
  };

  # simple way without using home manager xsession to map caps to escape
  # as there is no support for this option in xfconf
  # lightdm is reading this .xprofile out of the box on session login
  home.file.".xprofile".text = ''
    ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option caps:escape
  '';

  fonts.fontconfig.enable = true;

  imports = [ ./terminal.nix ./xfconf.nix ./i3.nix ];
}
