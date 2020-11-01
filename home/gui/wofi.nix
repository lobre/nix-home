{ config, pkgs, ... }:

let
  colors = import ./colors.nix;
in

{
  xdg.configFile."wofi/config".text = ''
  show=drun
  width=40%
  lines=10
  columns=1
  location=center
  orientation=vertical
  prompt=launch
  term=${config.programs.alacritty.package}/bin/alacritty
  hide_scroll=true
  matching=contains
  insensitive=true
  sort_order=default
  gtk_dark=true
  key_down=Control_L-n
  key_up=Control_R-p
  '';

  xdg.configFile."wofi/style.css".text = ''
  window {
    margin: 0px;
    border: 1px solid ${colors.gray-800};
    background-color: ${colors.gray-900};
  }

  #input {
    margin: 5px;
    border: none;
    color: #f8f8f2;
    background-color: ${colors.gray-900};
  }

  #inner-box {
    margin: 5px;
    border: none;
    background-color: ${colors.gray-900};
  }

  #outer-box {
    margin: 5px;
    border: none;
    background-color: ${colors.gray-900};
  }

  #scroll {
    margin: 0px;
    border: none;
  }

  #text {
    margin: 5px;
    border: none;
    color: ${colors.gray-100};
  } 

  #entry:selected {
    background-color: ${colors.blue-800};
  }
  '';
}
