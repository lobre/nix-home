{ config, pkgs, ... }:

let
  pname = "oni2";
  version = "0.5.0";
  description = "Native, lightweight modal code editor";

  oni2 = pkgs.appimageTools.wrapType2 rec {
    name = "${pname}-${version}";

    # The file needs to be downloaded and placed
    # at this location as it currently needs a token.
    src = ./oni2/Onivim2.AppImage;

    extraInstallCommands = ''
      # change binary name
      mv $out/bin/{${name},${pname}}
    '';

    meta = {
      description = "${description}";
      homepage = "https://onivim.github.io/";
      platforms = [ "x86_64-linux" ];
    };
  };

  oni2wrapper = pkgs.writeScriptBin "oni2" ''
    #!${pkgs.stdenv.shell}

    # if last argument is a path, transform it to an
    # absolute one so it works as expected in the FHS
    # environment
    args="$@"
    if [ $# -ne 0 ]; then
        lastArg=''${@:$#}
        if [[ ''${lastArg:0:1} != "-" ]]; then
            dir=$(readlink -m $lastArg)
            args="''${*%''${!#}} $dir"
        fi
    fi

    # As oni is executed inside a FHS, it will exit if the main process quit.
    # So we force oni to launch in foreground mode but detach from the process
    ${oni2}/bin/oni2 -- -f $args > /dev/null 2>&1 &
  '';

  dl-helper = pkgs.writeScriptBin "oni-dl-to" ''
    #!${pkgs.stdenv.shell}

    dest=''\${1%/}
    if [[ -z "$dest" ]]; then
      echo "Missing destination folder as first argument"
      exit 1
    elif [[ ! -d "$dest" ]]; then
      echo "Argument is not a directory"
      exit 1
    fi

    # appending filename
    dest="$dest/Onivim2.AppImage"

    # open browser to the DL page
    xdg-open https://v2.onivim.io/early-access-portal 2>/dev/null

    read -p "When file is downloaded, press enter"

    dl=$(xdg-user-dir DOWNLOAD)
    from="$dl/$(ls -rt $dl | tail -n1)"

    read -p "Found $from, press enter to move it to destination"
    echo "Moving $from to $dest"
    mv "$from" "$dest"

    echo "New version in place, please build oni2 now"
  '';
in

{
  home.packages = [ oni2wrapper dl-helper ];

  xdg.configFile."oni2/configuration.json".text = ''
    {
      "workbench.colorTheme": "One Dark Pro",
      "editor.detectIndentation": true,
      "editor.fontSize": 14,
      "editor.largeFileOptimizations": true,
      "editor.highlightActiveIndentGuide": true,
      "editor.indentSize": 4,
      "editor.insertSpaces": false,
      "editor.lineNumbers": "on",
      "editor.matchBrackets": true,
      "editor.minimap.enabled": true,
      "editor.minimap.maxColumn": 120,
      "editor.minimap.showSlider": true,
      "editor.renderIndentGuides": true,
      "editor.renderWhitespace": "all",
      "editor.rulers": [],
      "editor.tabSize": 4,
      "editor.zenMode.hideTabs": true,
      "editor.zenMode.singleFile": true,
      "files.exclude": [ "_esy", "node_modules" ],
      "go.useLanguageServer": true,
      "workbench.activityBar.visible": true,
      "workbench.editor.showTabs": true,
      "workbench.iconTheme": "vs-seti",
      "workbench.sideBar.visible": true,
      "workbench.statusBar.visible": true,
      "workbench.tree.indent": 2,
      "vim.useSystemClipboard": [ "yank" ],
      "experimental.viml": [] 
    }
  '';
}
