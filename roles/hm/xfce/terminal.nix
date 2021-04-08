let
  black="#15171C";
  red="#BF616A";
  green="#A3BE8C";
  yellow="#EBCB8B";
  blue="#81A1C1";
  magenta="#B48EAD";
  cyan="#89D0BA";
  white="#E5E9F0";

  brightBlack="#434A5A";
  brightRed="#B3555E";
  brightGreen="#93AE7C";
  brightYellow="#DBBB7B";
  brightBlue="#7191B1";
  brightMagenta="#A6809F";
  brightCyan="#7DBBA8";
  brightWhite="#D1D5DC";

  background="#0C0D10";
  foreground="#D8DEE8";

  palette = "${black};${red};${green};${yellow};${blue};${magenta};${cyan};${white};${brightBlack};${brightRed};${brightGreen};${brightYellow};${brightBlue};${brightMagenta};${brightCyan};${brightWhite}";
in 

{
  # keyboard shortcuts
  xdg.configFile."xfce4/terminal/accels.scm".text = ''
    (gtk_accel_path "<Actions>/terminal-window/next-tab" "<Primary>Tab")
    (gtk_accel_path "<Actions>/terminal-window/prev-tab" "<Primary><Shift>Tab")
  '';

  # general settings
  xdg.configFile."xfce4/terminal/terminalrc".text = ''
    [Configuration]
    FontUseSystem=TRUE
    MiscAlwaysShowTabs=FALSE
    MiscBell=FALSE
    MiscBellUrgent=FALSE
    MiscBordersDefault=TRUE
    MiscCursorBlinks=FALSE
    MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
    MiscDefaultGeometry=110x30
    MiscInheritGeometry=FALSE
    MiscMenubarDefault=FALSE
    MiscMouseAutohide=FALSE
    MiscMouseWheelZoom=TRUE
    MiscToolbarDefault=FALSE
    MiscConfirmClose=TRUE
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
  '';
}
