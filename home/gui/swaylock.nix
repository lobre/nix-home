{ config, pkgs, ... }:

let
  colors = import ./colors.nix;
  wallpaper = "$HOME/${config.xdg.dataFile."wallpaper.jpg".target}";
in

{
  xdg.configFile."swaylock/config".text = ''
  image=${wallpaper}
  scaling=stretch

  indicator-radius=40
  indicator-thickness=10
  indicator-idle-visible

  font=monospace
  font-size=10

  inside-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}
  inside-caps-lock-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}
  inside-ver-color=${builtins.replaceStrings ["#"] [""] "${colors.blue-800}"}
  inside-wrong-color=${builtins.replaceStrings ["#"] [""] "${colors.red-800}"}
  inside-clear-color=${builtins.replaceStrings ["#"] [""] "${colors.yellow-400}"}

  ring-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}
  ring-caps-lock-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}
  ring-ver-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}
  ring-wrong-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}
  ring-clear-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}

  key-hl-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-600}"}
  caps-lock-key-hl-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-600}"}
  bs-hl-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-600}"}
  caps-lock-bs-hl-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-600}"}

  separator-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}

  line-uses-ring
  
  text-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-100}"}
  text-caps-lock-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-100}"}
  text-clear-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}
  text-ver-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-100}"}
  text-wrong-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-100}"}

  layout-bg-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-800}"}
  layout-border-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-700}"}
  layout-text-color=${builtins.replaceStrings ["#"] [""] "${colors.gray-100}"}
  '';
}
