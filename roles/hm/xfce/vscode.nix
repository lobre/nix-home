{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      golang.go
      ms-vsliveshare.vsliveshare
      zhuangtongfa.material-theme
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
      "terminal.integrated.letterSpacing" = 1.5;
      "terminal.integrated.lineHeight" = 1.3;
      "workbench.colorTheme" = "One Dark Pro";

      # Colors
      "workbench.colorCustomizations" = {
        "editor.background" = "#21252b";
        "terminal.background" = "#21252b";
        "terminal.foreground" = "#e7ebed";

        "editorCursor.foreground" = "#e7ebed";
        "editorCursor.background" = "#000000";

        "terminal.ansiBlack" = "#243137";
        "terminal.ansiRed" = "#fc3841";
        "terminal.ansiGreen" = "#5cf19e";
        "terminal.ansiYellow" = "#fed032";
        "terminal.ansiBlue" = "#37b6ff";
        "terminal.ansiMagenta" = "#fc226e";
        "terminal.ansiCyan" = "#59ffd1";
        "terminal.ansiWhite" = "#ffffff";
        "terminal.ansiBrightBlack" = "#84A6B8";
        "terminal.ansiBrightRed" = "#fc746d";
        "terminal.ansiBrightGreen" = "#adf7be";
        "terminal.ansiBrightYellow" = "#fee16c";
        "terminal.ansiBrightBlue" = "#70cfff";
        "terminal.ansiBrightMagenta" = "#fc669b";
        "terminal.ansiBrightCyan" = "#9affe6";
        "terminal.ansiBrightWhite" = "#ffffff";
      };

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
      
      # Unbind some shortcuts to use default vscode
      { key = "ctrl+f"; command = "-vscode-neovim.ctrl-f"; } # search
      { key = "ctrl+b"; command = "-vscode-neovim.ctrl-b"; } # toggle sidebar
    ];
  };
}
