{
  # whisker menu
  xdg.configFile."xfce4/panel/whiskermenu-1.rc".text = ''
    favorites=
    recent=
    button-icon=xfce4-whiskermenu
    button-single-row=false
    show-button-title=true
    show-button-icon=true
    launcher-show-name=true
    launcher-show-description=true
    launcher-show-tooltip=true
    item-icon-size=3
    hover-switch-category=false
    category-show-name=true
    category-icon-size=1
    load-hierarchy=false
    view-as-icons=false
    recent-items-max=0
    favorites-in-recent=true
    display-recent-default=false
    position-search-alternate=true
    position-commands-alternate=false
    position-categories-alternate=true
    stay-on-focus-out=false
    confirm-session-command=true
    menu-width=450
    menu-height=500
    menu-opacity=100
    command-settings=xfce4-settings-manager
    show-command-settings=true
    command-lockscreen=xflock4
    show-command-lockscreen=true
    command-switchuser=gdmflexiserver
    show-command-switchuser=false
    command-logoutuser=xfce4-session-logout --logout --fast
    show-command-logoutuser=false
    command-restart=xfce4-session-logout --reboot --fast
    show-command-restart=false
    command-shutdown=xfce4-session-logout --halt --fast
    show-command-shutdown=false
    command-suspend=xfce4-session-logout --suspend
    show-command-suspend=false
    command-hibernate=xfce4-session-logout --hibernate
    show-command-hibernate=false
    command-logout=xfce4-session-logout
    show-command-logout=true
    command-menueditor=menulibre
    show-command-menueditor=true
    command-profile=mugshot
    show-command-profile=true
    search-actions=0
  '';

  # battery plugin
  xdg.configFile."xfce4/panel/battery-9.rc".text = ''
    display_label=false
    display_icon=true
    display_power=false
    display_percentage=false
    display_bar=false
    display_time=false
    tooltip_display_percentage=true
    tooltip_display_time=false
    low_percentage=10
    critical_percentage=5
    action_on_low=1
    action_on_critical=1
    hide_when_full=1
    colorA=rgb(136,136,255)
    colorH=rgb(0,255,0)
    colorL=rgb(255,255,0)
    colorC=rgb(255,0,0)
    command_on_low=
    command_on_critical=
  '';
  
  # disk space plugin
  xdg.configFile."xfce4/panel/fsguard-10.rc".text = ''
    yellow=8
    red=2
    lab_size_visible=false
    progress_bar_visible=false
    hide_button=false
    label=
    label_visible=false
    mnt=/
  '';

  # screenshot plugin
  xdg.configFile."xfce4/panel/screenshooter-12.rc".text = ''
    app=none
    last_user=
    screenshot_dir=
    action=1
    delay=0
    region=3
    show_mouse=1
  '';
}
