{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
  # Enable xsession
  xsession.enable = true;

  # To fix glibc locale bug (https://github.com/NixOS/nixpkgs/issues/38991)
  home.sessionVariables.LOCALE_ARCHIVE_2_27 = "${pkgs.glibcLocales}/lib/locale/locale-archive";

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
    xclip
    xcwd

    # apps
    discord
    filezilla
    firefox 
    gnome3.eog
    gnome3.gucharmap
    gnome3.meld
    google-chrome
    mattermost
    peek
    remmina
    rxvt_unicode 
    shutter
    skype
    slack-dark
    spotify
  ];

  gtk = {
    enable = true;
    font = {
      name = "${theme.font} 12";
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
    # could set something like "1h" or "30min"
    interval = null;
  };

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
    ./gui/urxvt.nix
    ./gui/xresources.nix
    ./gui/compton.nix
    ./gui/dunst.nix
  ];
}
