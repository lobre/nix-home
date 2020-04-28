{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
  # Enable xsession
  xsession.enable = true;

  # Enable numlock
  xsession.numlock.enable = true;

  # Used to configure xsession user service
  home.keyboard = {
    layout = "fr";
    variant = "bepo";

    # Use caps lock as escape
    options = [ "caps:escape" ];
  };

  home.packages = with pkgs; [
    # theme
    arc-icon-theme
    arc-theme

    # i3
    arandr
    picom
    haskellPackages.greenclip
    i3blocks
    i3lock-fancy
    i3status
    libnotify
    lxappearance
    networkmanagerapplet 
    pavucontrol
    shutter
    xautolock
    xclip
    xcwd

    # apps
    discord
    filezilla
    firefox 
    gnome3.gnome-control-center
    gnome3.eog
    gnome3.gucharmap
    gnome3.meld
    google-chrome
    mattermost-desktop
    peek
    remmina
    shutter
    skype
    slack-dark
    spotify
  ];

  gtk = {
    enable = true;
    font = {
      name = "${theme.font.family} 12";
      package = theme.font.package;
    };

    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Darker";
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  services.random-background = {
    enable = true;
    enableXinerama = true;
    display = "fill";
    imageDirectory = "%h/Pictures/Wallpapers";
    # could set something like "1h" or "30min"
    interval = null;
  };

  # Allow XDG linking
  xdg.enable = true;

  # Fonts
  fonts.fontconfig.enable = true;
  xdg.dataFile."fonts".source = ./gui/fonts;

  # Link scripts
  home.file."bin-gui" = {
    source = ./gui/bin;
    target = "bin";
    recursive = true;
  };

  imports = [
    ./gui/theme.nix
    ./gui/i3.nix
    ./gui/i3status.nix
    ./gui/rofi.nix
    ./gui/alacritty.nix
    ./gui/xresources.nix
    ./gui/picom.nix
    ./gui/dunst.nix
    ./gui/oni.nix
  ];
}
