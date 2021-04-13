{
  # whisker menu
  xdg.configFile."xfce4/panel/whiskermenu-1.rc".text = ''
    button-icon=xfce4-whiskermenu
    button-single-row=false
    category-icon-size=-1
    category-show-name=true
    command-hibernate=xfce4-session-logout --hibernate
    command-lockscreen=xflock4
    command-logout=xfce4-session-logout
    command-logoutuser=xfce4-session-logout --logout --fast
    command-menueditor=menulibre
    command-profile=mugshot
    command-restart=xfce4-session-logout --reboot --fast
    command-settings=xfce4-settings-manager
    command-shutdown=xfce4-session-logout --halt --fast
    command-suspend=xfce4-session-logout --suspend
    command-switchuser=gdmflexiserver
    confirm-session-command=true
    default-category=2
    favorites-in-recent=true
    favorites=
    hover-switch-category=false
    item-icon-size=3
    launcher-show-description=true
    launcher-show-name=true
    launcher-show-tooltip=true
    load-hierarchy=false
    menu-height=500
    menu-opacity=100
    menu-width=500
    position-categories-alternate=true
    position-commands-alternate=false
    position-search-alternate=true
    recent-items-max=0
    recent=
    search-actions=0
    show-button-icon=true
    show-button-title=true
    show-command-hibernate=false
    show-command-lockscreen=true
    show-command-logout=true
    show-command-logoutuser=false
    show-command-menueditor=true
    show-command-profile=true
    show-command-restart=false
    show-command-settings=true
    show-command-shutdown=false
    show-command-suspend=false
    show-command-switchuser=false
    stay-on-focus-out=false
    view-as-icons=true
  '';

  # screenshot plugin
  xdg.configFile."xfce4/panel/screenshooter-10.rc".text = ''
    app=none
    last_user=
    screenshot_dir=
    action=1
    delay=0
    region=3
    show_mouse=1
  '';
}
