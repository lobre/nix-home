{ pkgs, ... }:

{
  xdg.enable = true;

  home.packages = with pkgs; [
    calibre
    discord
    filezilla
    firefox
    gimp
    inkscape
    krita
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
    sqlitebrowser
    teams
    vlc
    xdotool
    xsel

    # font
    (iosevka-bin.override { variant = "sgr-iosevka-term-slab"; })
  ];

  # Create a krita desktop file to launch without Open GL for non NixOS
  xdg.systemDirs.data = let
    kritaNoGLDesktop = pkgs.makeDesktopItem {
      name = "Krita No GL";
      desktopName = "Krita No GL";
      genericName = "Digital Painting";
      comment = "Digital Painting";
      exec = "env QT_XCB_GL_INTEGRATION=none krita %F";
      icon = "krita";
      categories = [ "Qt" "KDE" "Graphics" "2DGraphics" "RasterGraphics" ];
      type = "Application";
    };
  in [ "${kritaNoGLDesktop}/share" ];

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

  imports = [ ./terminal.nix ./xfconf.nix ];
}
