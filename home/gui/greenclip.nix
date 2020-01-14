{ config, pkgs, ... }:

{
  xdg.configFile."greenclip.cfg".text = ''
    Config {
     maxHistoryLength = 50,
     historyPath = "~/.cache/greenclip.history",
     staticHistoryPath = "~/.cache/greenclip.staticHistory",
     imageCachePath = "/tmp/",
     usePrimarySelectionAsInput = True,
     blacklistedApps = []
    }
  '';
}
