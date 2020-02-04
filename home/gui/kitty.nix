{ config, pkgs, ... }:

let
  theme = config.theme;
in

{
  xdg.configFile."kitty/kitty.conf".text = ''
    # Fonts
    
    # You can specify different fonts for the bold/italic/bold-italic
    # variants. To get a full list of supported fonts use the `kitty
    # list-fonts` command. By default they are derived automatically, by
    # the OSes font system. Setting them manually is useful for font
    # families that have many weight variants like Book, Medium, Thick,
    # etc.
    font_family      ${theme.font.nerd-family}
    bold_font        auto
    italic_font      auto
    bold_italic_font auto
    
    # Font size (in pts)
    font_size 12.0
    
    # Change the size of each character cell kitty renders. You can use
    # either numbers, which are interpreted as pixels or percentages
    # (number followed by %), which are interpreted as percentages of the
    # unmodified values. You can use negative pixels or percentages less
    # than 100% to reduce sizes (but this might cause rendering
    # artifacts).
    adjust_line_height  0
    adjust_column_width 0
    
    # Choose how you want to handle multi-character ligatures. The
    # default is to always render them.  You can tell kitty to not render
    # them when the cursor is over them by using cursor to make editing
    # easier, or have kitty never render them at all by using always, if
    # you don't like them. The ligature strategy can be set per-window
    # either using the kitty remote control facility or by defining
    # shortcuts for it in kitty.conf.
    disable_ligatures never
    
    # Change the sizes of the lines used for the box drawing unicode
    # characters These values are in pts. They will be scaled by the
    # monitor DPI to arrive at a pixel value. There must be four values
    # corresponding to thin, normal, thick, and very thick lines.
    box_drawing_scale 0.001, 1, 1.5, 2
    
    # Cursor customization
    
    # Default cursor color
    cursor ${theme.colors.foreground}
    
    # Choose the color of text under the cursor. If you want it rendered
    # with the background color of the cell underneath instead, use the
    # special keyword: background
    cursor_text_color ${theme.colors.background}
    
    # The cursor shape can be one of (block, beam, underline)
    cursor_shape block
    
    # The interval (in seconds) at which to blink the cursor. Set to zero
    # to disable blinking. Negative values mean use system default. Note
    # that numbers smaller than repaint_delay will be limited to
    # repaint_delay.
    cursor_blink_interval -1
    
    # Stop blinking cursor after the specified number of seconds of
    # keyboard inactivity.  Set to zero to never stop blinking.
    cursor_stop_blinking_after 15.0
    
    # Scrollback
    
    # Number of lines of history to keep in memory for scrolling back.
    # Memory is allocated on demand. Negative numbers are (effectively)
    # infinite scrollback. Note that using very large scrollback is not
    # recommended as it can slow down resizing of the terminal and also
    # use large amounts of RAM.
    scrollback_lines 2000
    
    # Program with which to view scrollback in a new window. The
    # scrollback buffer is passed as STDIN to this program. If you change
    # it, make sure the program you use can handle ANSI escape sequences
    # for colors and text formatting. INPUT_LINE_NUMBER in the command
    # line above will be replaced by an integer representing which line
    # should be at the top of the screen.
    scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER
    
    # Separate scrollback history size, used only for browsing the
    # scrollback buffer (in MB). This separate buffer is not available
    # for interactive scrolling but will be piped to the pager program
    # when viewing scrollback buffer in a separate window. The current
    # implementation stores one character in 4 bytes, so approximatively
    # 2500 lines per megabyte at 100 chars per line. A value of zero or
    # less disables this feature. The maximum allowed size is 4GB.
    scrollback_pager_history_size 0
    
    # Modify the amount scrolled by the mouse wheel. Note this is only
    # used for low precision scrolling devices, not for high precision
    # scrolling on platforms such as macOS and Wayland. Use negative
    # numbers to change scroll direction.
    wheel_scroll_multiplier 5.0
    
    # Modify the amount scrolled by a touchpad. Note this is only used
    # for high precision scrolling devices on platforms such as macOS and
    # Wayland. Use negative numbers to change scroll direction.
    touch_scroll_multiplier 1.0
    
    # Mouse
    
    # Hide mouse cursor after the specified number of seconds of the
    # mouse not being used. Set to zero to disable mouse cursor hiding.
    # Set to a negative value to hide the mouse cursor immediately when
    # typing text. Disabled by default on macOS as getting it to work
    # robustly with the ever-changing sea of bugs that is Cocoa is too
    # much effort.
    mouse_hide_wait 3.0
    
    # The color and style for highlighting URLs on mouse-over. url_style
    # can be one of: none, single, double, curly
    url_color ${theme.colors.color3}
    url_style single
    
    # The modifier keys to press when clicking with the mouse on URLs to
    # open the URL
    open_url_modifiers kitty_mod
    
    # The program with which to open URLs that are clicked on. The
    # special value default means to use the operating system's default
    # URL handler.
    open_url_with default
    
    # Copy to clipboard or a private buffer on select. With this set to
    # clipboard, simply selecting text with the mouse will cause the text
    # to be copied to clipboard. Useful on platforms such as macOS that
    # do not have the concept of primary selections. You can instead
    # specify a name such as a1 to copy to a private kitty buffer
    # instead. Map a shortcut with the paste_from_buffer action to paste
    # from this private buffer.
    copy_on_select no
    
    # Remove spaces at the end of lines when copying to clipboard. A
    # value of smart will do it when using normal selections, but not
    # rectangle selections. always will always do it.
    strip_trailing_spaces never
    
    # The modifiers to use rectangular selection (i.e. to select text in
    # a rectangular block with the mouse)
    rectangle_select_modifiers ctrl+alt
    
    # The modifiers to override mouse selection even when a terminal
    # application has grabbed the mouse
    terminal_select_modifiers shift
    
    # Characters considered part of a word when double clicking. In
    # addition to these characters any character that is marked as an
    # alphanumeric character in the unicode database will be matched.
    select_by_word_characters :@-./_~?&=%+#
    
    # The interval between successive clicks to detect double/triple
    # clicks (in seconds). Negative numbers will use the system default
    # instead, if available, or fallback to 0.5.
    click_interval -1.0
    
    # Set the active window to the window under the mouse when moving the
    # mouse around
    focus_follows_mouse no
    
    # The shape of the mouse pointer when the program running in the
    # terminal grabs the mouse. Valid values are: arrow, beam and hand
    pointer_shape_when_grabbed arrow
    
    # Performance tuning
    
    # Delay (in milliseconds) between screen updates. Decreasing it,
    # increases frames-per-second (FPS) at the cost of more CPU usage.
    # The default value yields ~100 FPS which is more than sufficient for
    # most uses. Note that to actually achieve 100 FPS you have to either
    # set sync_to_monitor to no or use a monitor with a high refresh
    # rate. Also, to minimize latency when there is pending input to be
    # processed, repaint_delay is ignored.
    repaint_delay 10
    
    # Delay (in milliseconds) before input from the program running in
    # the terminal is processed. Note that decreasing it will increase
    # responsiveness, but also increase CPU usage and might cause flicker
    # in full screen programs that redraw the entire screen on each loop,
    # because kitty is so fast that partial screen updates will be drawn.
    input_delay 3
    
    # Sync screen updates to the refresh rate of the monitor. This
    # prevents tearing (https://en.wikipedia.org/wiki/Screen_tearing)
    # when scrolling. However, it limits the rendering speed to the
    # refresh rate of your monitor. With a very high speed mouse/high
    # keyboard repeat rate, you may notice some slight input latency. If
    # so, set this to no.
    sync_to_monitor yes
    
    # Terminal bell
    
    # Enable/disable the audio bell. Useful in environments that require
    # silence.
    enable_audio_bell yes
    
    # Visual bell duration. Flash the screen when a bell occurs for the
    # specified number of seconds. Set to zero to disable.
    visual_bell_duration 0.0
    
    # Request window attention on bell. Makes the dock icon bounce on
    # macOS or the taskbar flash on linux.
    window_alert_on_bell yes
    
    # Show a bell symbol on the tab if a bell occurs in one of the
    # windows in the tab and the window is not the currently focused
    # window
    bell_on_tab yes
    
    # Program to run when a bell occurs.
    command_on_bell none
    
    # Window layout
    
    # If enabled, the window size will be remembered so that new
    # instances of kitty will have the same size as the previous
    # instance. If disabled, the window will initially have size
    # configured by initial_window_width/height, in pixels. You can use a
    # suffix of "c" on the width/height values to have them interpreted
    # as number of cells instead of pixels.
    remember_window_size  yes
    initial_window_width  640
    initial_window_height 400
    
    # The enabled window layouts. A comma separated list of layout names.
    # The special value all means all layouts. The first listed layout
    # will be used as the startup layout. For a list of available
    # layouts, see the
    # https://sw.kovidgoyal.net/kitty/index.html#layouts.
    enabled_layouts *
    
    # The step size (in units of cell width/cell height) to use when
    # resizing windows. The cells value is used for horizontal resizing
    # and the lines value for vertical resizing.
    window_resize_step_cells 2
    window_resize_step_lines 2
    
    # The width (in pts) of window borders. Will be rounded to the
    # nearest number of pixels based on screen resolution. Note that
    # borders are displayed only when more than one window is visible.
    # They are meant to separate multiple windows.
    window_border_width 2.0
    
    # Draw only the minimum borders needed. This means that only the
    # minimum needed borders for inactive windows are drawn. That is only
    # the borders that separate the inactive window from a neighbor. Note
    # that setting a non-zero window margin overrides this and causes all
    # borders to be drawn.
    draw_minimal_borders yes
    
    # The window margin (in pts) (blank area outside the border)
    window_margin_width 0.0
    
    # The window margin (in pts) to use when only a single window is
    # visible. Negative values will cause the value of
    # window_margin_width to be used instead.
    single_window_margin_width -1000.0
    
    # The window padding (in pts) (blank area between the text and the
    # window border)
    window_padding_width 15
    
    # When the window size is not an exact multiple of the cell size, the
    # cell area of the terminal window will have some extra padding on
    # the sides. You can control how that padding is distributed with
    # this option. Using a value of center means the cell area will be
    # placed centrally. A value of top-left means the padding will be on
    # only the bottom and right edges.
    placement_strategy center
    
    # The color for the border of the active window. Set this to none to
    # not draw borders around the active window.
    active_border_color ${theme.colors.color4}
    
    # The color for the border of inactive windows
    inactive_border_color ${theme.colors.foreground}
    
    # The color for the border of inactive windows in which a bell has
    # occurred
    bell_border_color ${theme.colors.background}
    
    # Fade the text in inactive windows by the specified amount (a number
    # between zero and one, with zero being fully faded).
    inactive_text_alpha 1.0
    
    # Hide the window decorations (title-bar and window borders). Whether
    # this works and exactly what effect it has depends on the window
    # manager/operating system.
    hide_window_decorations no
    
    # The time (in seconds) to wait before redrawing the screen when a
    # resize event is received. On platforms such as macOS, where the
    # operating system sends events corresponding to the start and end of
    # a resize, this number is ignored.
    resize_debounce_time 0.1
    
    # Choose how kitty draws a window while a resize is in progress. A
    # value of static means draw the current window contents, mostly
    # unchanged. A value of scale means draw the current window contents
    # scaled. A value of blank means draw a blank window. A value of size
    # means show the window size in cells.
    resize_draw_strategy static
    
    # Tab bar
    
    # Which edge to show the tab bar on, top or bottom
    tab_bar_edge bottom
    
    # The margin to the left and right of the tab bar (in pts)
    tab_bar_margin_width 0.0
    
    # The tab bar style, can be one of: fade, separator, powerline, or
    # hidden. In the fade style, each tab's edges fade into the
    # background color, in the separator style, tabs are separated by a
    # configurable separator, and the powerline shows the tabs as a
    # continuous line.
    tab_bar_style fade
    
    # The minimum number of tabs that must exist before the tab bar is
    # shown
    tab_bar_min_tabs 2
    
    # The algorithm to use when switching to a tab when the current tab
    # is closed. The default of previous will switch to the last used
    # tab. A value of left will switch to the tab to the left of the
    # closed tab. A value of last will switch to the right-most tab.
    tab_switch_strategy previous
    
    # Control how each tab fades into the background when using fade for
    # the tab_bar_style. Each number is an alpha (between zero and one)
    # that controls how much the corresponding cell fades into the
    # background, with zero being no fade and one being full fade. You
    # can change the number of cells used by adding/removing entries to
    # this list.
    tab_fade 0.25 0.5 0.75 1
    
    # The separator between tabs in the tab bar when using separator as
    # the tab_bar_style.
    tab_separator " ┇"
    
    # A template to render the tab title. The default just renders the
    # title. If you wish to include the tab-index as well, use something
    # like: {index}: {title}. Useful if you have shortcuts mapped for
    # goto_tab N.
    tab_title_template {title}
    
    # Template to use for active tabs, if not specified falls back to
    # tab_title_template.
    active_tab_title_template none
    
    # Tab bar colors and styles
    active_tab_foreground   ${theme.colors.background}
    active_tab_background   ${theme.colors.color4}
    active_tab_font_style   bold-italic
    inactive_tab_foreground ${theme.colors.foreground}
    inactive_tab_background ${theme.colors.background}
    inactive_tab_font_style normal
    
    # Background color for the tab bar. Defaults to using the terminal
    # background color.
    tab_bar_background none
    
    # Color scheme
    
    # The foreground and background colors
    foreground ${theme.colors.foreground}
    background ${theme.colors.background}
    
    # The opacity of the background. A number between 0 and 1, where 1 is
    # opaque and 0 is fully transparent.  This will only work if
    # supported by the OS (for instance, when using a compositor under
    # X11). Note that it only sets the default background color's
    # opacity. This is so that things like the status bar in vim,
    # powerline prompts, etc. still look good.  But it means that if you
    # use a color theme with a background color in your editor, it will
    # not be rendered as transparent.  Instead you should change the
    # default background color in your kitty config and not use a
    # background color in the editor color scheme. Or use the escape
    # codes to set the terminals default colors in a shell script to
    # launch your editor.  Be aware that using a value less than 1.0 is a
    # (possibly significant) performance hit.  If you want to dynamically
    # change transparency of windows set dynamic_background_opacity to
    # yes (this is off by default as it has a performance cost)
    background_opacity 1.0
    
    # Allow changing of the background_opacity dynamically, using either
    # keyboard shortcuts (increase_background_opacity and
    # decrease_background_opacity) or the remote control facility.
    dynamic_background_opacity no
    
    # How much to dim text that has the DIM/FAINT attribute set. One
    # means no dimming and zero means fully dimmed (i.e. invisible).
    dim_opacity 0.75
    
    # The foreground for text selected with the mouse. A value of none
    # means to leave the color unchanged.
    selection_foreground ${theme.colors.background}
    
    # The background for text selected with the mouse.
    selection_background ${theme.colors.foreground}
    
    # The 16 terminal colors. There are 8 basic colors, each color has a
    # dull and bright version. You can also set the remaining colors from
    # the 256 color table as color16 to color255.
    
    # black
    color0 ${theme.colors.dark}
    color8 ${theme.colors.darkAlt}
    
    # red
    color1 ${theme.colors.color1}
    color9 ${theme.colors.color1Alt}
    
    # green
    color2  ${theme.colors.color2}
    color10 ${theme.colors.color2Alt}
    
    # yellow
    color3  ${theme.colors.color3}
    color11 ${theme.colors.color3Alt}
    
    # blue
    color4  ${theme.colors.color4}
    color12 ${theme.colors.color4Alt}
    
    # magenta
    color5  ${theme.colors.color5}
    color13 ${theme.colors.color5Alt}
    
    # cyan
    color6  ${theme.colors.color6}
    color14 ${theme.colors.color6Alt}
    
    # white
    color7  ${theme.colors.light}
    color15 ${theme.colors.lightAlt}
    
    # Advanced
    
    # The shell program to execute. The default value of . means to use
    # whatever shell is set as the default shell for the current user.
    # Note that on macOS if you change this, you might need to add
    # --login to ensure that the shell starts in interactive mode and
    # reads its startup rc files.
    shell .
    
    # The console editor to use when editing the kitty config file or
    # similar tasks. A value of . means to use the environment variables
    # VISUAL and EDITOR in that order. Note that this environment
    # variable has to be set not just in your shell startup scripts but
    # system-wide, otherwise kitty will not see it.
    editor .
    
    # Close the window when the child process (shell) exits. If no (the
    # default), the terminal will remain open when the child exits as
    # long as there are still processes outputting to the terminal (for
    # example disowned or backgrounded processes). If yes, the window
    # will close as soon as the child process exits. Note that setting it
    # to yes means that any background processes still using the terminal
    # can fail silently because their stdout/stderr/stdin no longer work.
    close_on_child_death no
    
    # Allow other programs to control kitty. If you turn this on other
    # programs can control all aspects of kitty, including sending text
    # to kitty windows, opening new windows, closing windows, reading the
    # content of windows, etc.  Note that this even works over ssh
    # connections. You can chose to either allow any program running
    # within kitty to control it, with yes or only programs that connect
    # to the socket specified with the kitty --listen-on command line
    # option, if you use the value socket-only. The latter is useful if
    # you want to prevent programs running on a remote computer over ssh
    # from controlling kitty.
    allow_remote_control no
    
    # Periodically check if an update to kitty is available. If an update
    # is found a system notification is displayed informing you of the
    # available update. The default is to check every 24 hrs, set to zero
    # to disable.
    update_check_interval 0
    
    # Path to a session file to use for all kitty instances. Can be
    # overridden by using the kitty --session command line option for
    # individual instances. See
    # https://sw.kovidgoyal.net/kitty/index.html#sessions in the kitty
    # documentation for details. Note that relative paths are interpreted
    # with respect to the kitty config directory. Environment variables
    # in the path are expanded.
    startup_session none
    
    # Allow programs running in kitty to read and write from the
    # clipboard. You can control exactly which actions are allowed. The
    # set of possible actions is: write-clipboard read-clipboard write-
    # primary read-primary. You can additionally specify no-append to
    # disable kitty's protocol extension for clipboard concatenation. The
    # default is to allow writing to the clipboard and primary selection
    # with concatenation enabled. Note that enabling the read
    # functionality is a security risk as it means that any program, even
    # one running on a remote server via SSH can read your clipboard.
    clipboard_control write-clipboard write-primary
    
    # The value of the TERM environment variable to set. Changing this
    # can break many terminal programs, only change it if you know what
    # you are doing, not because you read some advice on Stack Overflow
    # to change it. The TERM variable is used by various programs to get
    # information about the capabilities and behavior of the terminal. If
    # you change it, depending on what programs you run, and how
    # different the terminal you are changing it to is, various things
    # from key-presses, to colors, to various advanced features may not
    # work.
    term xterm-kitty
    
    # OS specific tweaks
    
    # Choose between Wayland and X11 backends. By default, an appropriate
    # backend based on the system state is chosen automatically. Set it
    # to x11 or wayland to force the choice.
    linux_display_server auto
    
    # Keyboard shortcuts
    
    # For a list of key names, see: GLFW keys
    # <https://www.glfw.org/docs/latest/group__keys.html>. The name to
    # use is the part after the GLFW_KEY_ prefix. For a list of modifier
    # names, see: GLFW mods
    # <https://www.glfw.org/docs/latest/group__mods.html>
    
    # On Linux you can also use XKB key names to bind keys that are not
    # supported by GLFW. See XKB keys
    # <https://github.com/xkbcommon/libxkbcommon/blob/master/xkbcommon/xkbcommon-
    # keysyms.h> for a list of key names. The name to use is the part
    # after the XKB_KEY_ prefix. Note that you should only use an XKB key
    # name for keys that are not present in the list of GLFW keys.
    
    # The value of kitty_mod is used as the modifier for all default
    # shortcuts, you can change it in your kitty.conf to change the
    # modifiers for all the default shortcuts.
    kitty_mod ctrl+shift
    
    # You can have kitty remove all shortcut definition seen up to this
    # point. Useful, for instance, to remove the default shortcuts.
    clear_all_shortcuts no
    
    # Clipboard
    
    # There is also a copy_or_interrupt action that can be optionally
    # mapped to Ctrl+c. It will copy only if there is a selection and
    # send an interrupt otherwise.
    map kitty_mod+c copy_to_clipboard
    
    # You can also pass the contents of the current selection to any
    # program using pass_selection_to_program. By default, the system's
    # open program is used, but you can specify your own, the selection
    # will be passed as a command line argument to the program.
    map kitty_mod+v  paste_from_clipboard
    
    # Scrolling
    
    map kitty_mod+up        scroll_line_up
    map kitty_mod+s         scroll_line_up
    map kitty_mod+down      scroll_line_down
    map kitty_mod+t         scroll_line_down
    map kitty_mod+page_up   scroll_page_up
    map kitty_mod+page_down scroll_page_down
    map kitty_mod+home      scroll_home
    map kitty_mod+end       scroll_end
    map kitty_mod+g         show_scrollback
    
    # Window management
    
    map kitty_mod+enter new_window

    map kitty_mod+f     next_window
    map kitty_mod+b     previous_window
    map kitty_mod+alt+f move_window_forward
    map kitty_mod+alt+b move_window_backward
    map kitty_mod+h     start_resizing_window
    map kitty_mod+1     first_window
    map kitty_mod+2     second_window
    map kitty_mod+3     third_window
    map kitty_mod+4     fourth_window
    map kitty_mod+5     fifth_window
    map kitty_mod+6     sixth_window
    map kitty_mod+7     seventh_window
    map kitty_mod+8     eighth_window
    map kitty_mod+9     ninth_window
    map kitty_mod+0     tenth_window
    
    # Tab management
    
    map kitty_mod+n     next_tab
    map kitty_mod+p     previous_tab
    map kitty_mod+w     new_tab
    map kitty_mod+q     close_tab
    map kitty_mod+alt+n move_tab_forward
    map kitty_mod+alt+p move_tab_backward
    map kitty_mod+,     set_tab_title
    
    # Layout management
    
    map kitty_mod+l>n next_layout
    map kitty_mod+l>p last_used_layout 
    map kitty_mod+l>f goto_layout fat
    map kitty_mod+l>g goto_layout grid
    map kitty_mod+l>h goto_layout horizontal
    map kitty_mod+l>s goto_layout stack
    map kitty_mod+l>t goto_layout tall
    map kitty_mod+l>v goto_layout vertical
    
    # Font sizes
    
    # Select and act on visible text
    map kitty_mod+plus change_font_size all +2.0
    map kitty_mod+minus change_font_size all -2.0
    map kitty_mod+equal change_font_size all 0
    
    # Open a currently visible URL using the keyboard. The program used
    # to open the URL is specified in open_url_with.
    map kitty_mod+space>u kitten hints
    
    # Select a path/filename and insert it into the terminal. Useful, for
    # instance to run git commands on a filename output from a previous
    # git command.
    map kitty_mod+space>p kitten hints --type path --program -
    
    # Select a line of text and insert it into the terminal. Use for the
    # output of things like: ls -1
    map kitty_mod+space>l kitten hints --type line --program -
    
    # Select words and insert into terminal.
    map kitty_mod+space>w kitten hints --type word --program -
    
    # Select something that looks like a hash and insert it into the
    # terminal. Useful with git, which uses sha1 hashes to identify
    # commits
    map kitty_mod+space>h kitten hints --type hash --program -
    
    # Miscellaneous
    
    map kitty_mod+f11    toggle_fullscreen
    map kitty_mod+f10    toggle_maximized
    map kitty_mod+u      kitten unicode_input

    # Open the kitty shell in a new window/tab/overlay/os_window to
    # control kitty using commands.
    map kitty_mod+escape kitty_shell window
    
    map kitty_mod+delete clear_terminal reset active
  '';
}
