{ pkgs, ... }:

let
  config = {
    "[go]" = {
      "editor.formatOnSave" = true;
    };
    "experimental.viml" = [
      "tnoremap <ESC> <C-\\><C-n>"
    ];
  };
in

{
  xdg.configFile."oni2/configuration.json".text = (builtins.toJSON config);
}
