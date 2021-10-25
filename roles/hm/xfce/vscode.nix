{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-vsliveshare.vsliveshare
      asvetliakov.vscode-neovim
      golang.go
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vsc-material-theme";
        publisher = "Equinusocio";
        version = "33.2.2";
        sha256 = "0a55ksf58d4fhk1vgafibxkg61rhyd6cl10wz9gwg22rykx6i8d9";
      }
      {
        name = "vsc-material-theme-icons";
        publisher = "equinusocio";
        version = "2.2.1";
        sha256 = "03mxvm8c9zffzykc84n2y34jzl3l7jvnsvnqwn6gk9adzfd2bh41";
      }
    ];

    userSettings = {
      "update.mode" = "none";

      # Better defaults
      "diffEditor.ignoreTrimWhitespace" = false;
      "diffEditor.renderSideBySide" = false;
      "editor.copyWithSyntaxHighlighting" = false;
      "editor.detectIndentation" = false;
      "editor.emptySelectionClipboard" = false;
      "editor.multiCursorModifier" = "ctrlCmd";
      "files.trimTrailingWhitespace" = true;
      "window.newWindowDimensions" = "inherit";
      "workbench.editor.enablePreview" = false;

      # Hide everything
      "editor.lineNumbers" = "off";
      "editor.minimap.enabled" = false;
      "editor.renderIndentGuides" = false;
      "window.menuBarVisibility" = "hidden";
      "workbench.activityBar.visible" = false;
      "workbench.sideBar.location" = "right";

      # Silence the noise
      "breadcrumbs.enabled" = false;
      "editor.colorDecorators" = false;
      "editor.gotoLocation.multipleDeclarations" = "goto";
      "editor.gotoLocation.multipleDefinitions" = "goto";
      "editor.gotoLocation.multipleImplementations" = "goto";
      "editor.gotoLocation.multipleReferences" = "goto";
      "editor.gotoLocation.multipleTypeDefinitions" = "goto";
      "editor.hideCursorInOverviewRuler" = true;
      "editor.hover.enabled" = false;
      "editor.lightbulb.enabled" = false;
      "editor.matchBrackets" = "never";
      "editor.occurrencesHighlight" = false;
      "editor.overviewRulerBorder" = false;
      "editor.renderControlCharacters" = false;
      "editor.renderLineHighlight" = "none";
      "editor.selectionHighlight" = false;
      "git.decorations.enabled" = false;
      "problems.decorations.enabled" = false;
      "scm.diffDecorations" = "none";
      "workbench.editor.enablePreviewFromQuickOpen" = false;
      "workbench.startupEditor" = "none";
      "workbench.tips.enabled" = false;

      # Typography
      "editor.fontFamily" = "MonoLisa";
      "editor.fontSize" = 14;
      "editor.fontWeight" = "400";
      "editor.fontLigatures" = "'calt' on, 'liga' on, 'ss02' on";
      "editor.lineHeight" = 30;
      "editor.suggestFontSize" = 14;
      "editor.suggestLineHeight" = 28;
      "terminal.integrated.fontSize" = 14;
      "terminal.integrated.lineHeight" = 1.5;
      "workbench.colorTheme" = "Palenight Theme";

      # Neovim
      "vscode-neovim.neovimExecutablePaths.linux" = "${config.programs.neovim.package}/bin/nvim";

      # Go tooling
      "go.toolsManagement.checkForUpdates" = "off";
      "go.alternateTools" = {
        "gopls" = "${pkgs.gopls}/bin/gopls"; 
      };
    };

    keybindings = [
      # Terminal
      {
        key = "ctrl+t";
        command = "workbench.action.terminal.toggleTerminal";
      }

      # File explorer
      {
        key = "ctrl+n";
        command = "explorer.newFile";
        when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
      }
      {
        key = "ctrl+shift+n";
        command = "explorer.newFolder";
        when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
      }

      # Bring normal search back
      {
        key = "ctrl+f";
        command = "-vscode-neovim.ctrl-f";
        when = "editorTextFocus && neovim.ctrlKeysNormal && neovim.init && neovim.mode != 'insert'";
      }
    ];
  };
}
