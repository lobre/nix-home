{ config, pkgs, ... }:

{
  xdg.configFile."greenclip.cfg".text = ''
    Config {
     maxHistoryLength = 500,
     historyPath = "~/.cache/greenclip.history",
     staticHistoryPath = "~/.cache/greenclip.staticHistory",
     imageCachePath = "/tmp/",
     usePrimarySelectionAsInput = True,
     blacklistedApps = [],
     trimSpaceFromSelection = True
    }
  '';
}
