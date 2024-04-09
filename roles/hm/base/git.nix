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

    ignores = [ "tags" "tags.lock" "tags.temp" ".kak/" ];

    extraConfig = {
      core = {
        editor = "nvim";
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

      diff = {
        tool = "nvimdiff";
        submodule = "log";
      };

      difftool = {
        prompt = false;
        nvimdiff.cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
      };

      merge.tool = "nvimdiff";

      mergetool = {
        prompt = false;
        keepBackup = false;
        nvimdiff.cmd = "nvim -d \"$LOCAL\" \"$REMOTE\" \"$MERGED\" -c '$wincmd w' -c 'wincmd J'";
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






