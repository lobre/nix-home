{ pkgs, ... }:

let
  black = "#243137";
  red = "#fc3841";
  green = "#5cf19e";
  yellow = "#fed032";
  blue = "#37b6ff";
  magenta = "#fc226e";
  cyan = "#59ffd1";
  white = "#ffffff";

  brightBlack = "#84A6B8";
  brightRed = "#fc746d";
  brightGreen = "#adf7be";
  brightYellow = "#fee16c";
  brightBlue = "#70cfff";
  brightMagenta = "#fc669b";
  brightCyan = "#9affe6";
  brightWhite = "#ffffff";

  background = "#1d262a";
  foreground = "#e7ebed";

  palette =
    "${black};${red};${green};${yellow};${blue};${magenta};${cyan};${white};${brightBlack};${brightRed};${brightGreen};${brightYellow};${brightBlue};${brightMagenta};${brightCyan};${brightWhite}";

in
{
  # theme
  xdg.dataFile."xfce4/terminal/colorschemes/custom.theme".text = ''
    [Scheme]
    Name=Custom
    ColorForeground=${foreground}
    ColorBackground=${background}
    ColorPalette=${palette}
    ColorBoldIsBright=FALSE
  '';

  # keyboard shortcuts
  xdg.configFile."xfce4/terminal/accels.scm".text = ''
    (gtk_accel_path "<Actions>/terminal-window/next-tab" "<Primary>Tab")
    (gtk_accel_path "<Actions>/terminal-window/prev-tab" "<Primary><Shift>Tab")
  '';

  # padding around windows
  gtk = {
    enable = true;
    gtk3.extraCss = ''
      VteTerminal, vte-terminal { padding: 16px 20px; }
    '';
  };

  # general settings
  xdg.configFile."xfce4/terminal/terminalrc".text = ''
    [Configuration]
    CellHeightScale=1.200000
    FontName=Iosevka Term Slab Regular 12
    MiscAlwaysShowTabs=FALSE
    MiscBell=FALSE
    MiscBellUrgent=FALSE
    MiscBordersDefault=TRUE
    MiscCursorBlinks=FALSE
    MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
    MiscDefaultGeometry=110x20
    MiscInheritGeometry=FALSE
    MiscMenubarDefault=FALSE
    MiscMouseAutohide=FALSE
    MiscMouseWheelZoom=TRUE
    MiscToolbarDefault=FALSE
    MiscConfirmClose=FALSE
    MiscCycleTabs=TRUE
    MiscTabCloseButtons=TRUE
    MiscTabCloseMiddleClick=TRUE
    MiscTabPosition=GTK_POS_TOP
    MiscHighlightUrls=TRUE
    MiscMiddleClickOpensUri=FALSE
    MiscCopyOnSelect=FALSE
    MiscShowRelaunchDialog=TRUE
    MiscRewrapOnResize=TRUE
    MiscUseShiftArrowsToScroll=FALSE
    MiscSlimTabs=TRUE
    MiscNewTabAdjacent=FALSE
    MiscSearchDialogOpacity=100
    MiscShowUnsafePasteDialog=FALSE
    ScrollingBar=TERMINAL_SCROLLBAR_NONE
    ScrollingUnlimited=TRUE
    ShortcutsNoMnemonics=TRUE
    TitleMode=TERMINAL_TITLE_REPLACE
    ColorForeground=${foreground}
    ColorBackground=${background}
    ColorPalette=${palette}
    ColorBoldIsBright=FALSE
  '';
}
