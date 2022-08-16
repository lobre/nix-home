{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    discord
    filezilla
    firefox
    libnotify
    libreoffice
    meld
    pavucontrol
    peek
    pinta
    qtpass
    remmina
    slack
    spotify
    teams
    vlc
    xclip
    xdotool

    # font
    (iosevka.override {
      set = "term-slab";
      privateBuildPlan = {
        family = "Iosevka Term Slab";
        spacing = "term";
        serifs = "slab";
      };
    })
  ];

  programs.browserpass.enable = true;
  fonts.fontconfig.enable = true;

  imports = [
    ./terminal.nix
    ./xfconf.nix
  ];
}
