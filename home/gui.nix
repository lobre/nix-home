{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow XDG linking
  xdg.enable = true;

  # Enable xsession
  xsession.enable = true;

  # Used to configure xsession user service
  home.keyboard.layout = "fr";
  home.keyboard.variant = "bepo";

  home.packages = with pkgs; [
    # theme
    arc-icon-theme
    arc-theme

    # i3
    arandr
    compton
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
    xcwd

    # apps
    firefox 
    gnome3.eog
    gnome3.gucharmap
    google-chrome
    rxvt_unicode 
    spotify
  ];

  gtk = {
    enable = true;
    font = {
      name = "M+ 1mn 12";
      package = pkgs.mplus-outline-fonts;
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
    interval = "20min";
  };

  # Fonts
  fonts.fontconfig.enable = true;
  xdg.dataFile."fonts".source = ./gui/fonts;

  # Link scripts
  home.file."bin" = {
    source = ./gui/bin;
    recursive = true;
  };

  imports = [
    ./gui/i3.nix
    ./gui/i3status.nix
    ./gui/rofi.nix
    ./gui/urxvt.nix
    ./gui/xresources.nix
    ./gui/compton.nix
    ./gui/dunst.nix
  ];
}
