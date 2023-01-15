{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "loric.brevet@gmail.com";
    userName = "Loric Brevet";

    signing = {
      key = null; # signing key will depend on commit’s author
      signByDefault = true;
    };

    ignores = [ "tags" "tags.lock" "tags.temp" ];

    extraConfig = {
      core = {
        editor = "vim";
        askpass = "";
        pager = "less --mouse"; # allow mouse scroll
      };

      credential.helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";

      init.defaultBranch = "main";

      pull.rebase = true;
      push = {
        default = "current";
        autoSetupRemote = true;
      };

      merge.tool = "vimdiff";
      mergetool = {
        prompt = false;
        keepBackup = false;
      };

      difftool.prompt = false;
      diff = {
        tool = "vimdiff";
        submodule = "log";
      };

      status.submoduleSummary = true;
      submodule = {
        recurse = true;
        fetchJobs = 8;
      };
    };

    lfs.enable = true;

    includes = [{ path = "~/.gitconfig.local"; }];
  };
}






