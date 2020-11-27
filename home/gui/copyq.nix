{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
    copyq
  ];

  xdg.configFile."autostart/custom-command0.desktop".text = ''
    [Desktop Entry]
    Name[en_GB]=Custom Command
    Comment[en_GB]=copyq
    Exec=copyq
    Icon=application-default-icon
    X-GNOME-Autostart-enabled=true
    Type=Application
  '';
}

