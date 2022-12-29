{ pkgs, secrets, ... }:

{
  programs.git = {
    enable = true;
    userEmail = secrets.email;
    userName = secrets.name;

    signing = {
      key = null; # signing key will depend on commit’s author
      signByDefault = true;
    };

    aliases = {
      "ls" =
        "log -i --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
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
