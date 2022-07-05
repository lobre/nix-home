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
      "ls" = "log -i --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };

    ignores = [
      "tags"
      "tags.lock"
      "tags.temp"
    ];

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      push = {
        default = "current";
      };
      pull = {
        rebase = true;
      };
      core = {
        editor = "vim";
        askpass = "";
      };
      credential = {
        helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
      };
      merge = {
        tool = "vimdiff";
      };
      mergetool = {
        prompt = false;
        keepBackup = false;
      };
      diff = {
        tool = "vimdiff";
        submodule = "log";
      };
      difftool = {
        prompt = false;
      };
      status = {
        submoduleSummary = true;
      };
      submodule = {
        recurse = true;
        fetchJobs = 8;
      };
    };

    lfs.enable = true;

    difftastic = {
      enable = true;
      background = "dark";
    };

    includes = [ { path = "~/.gitconfig.local"; } ];
  };
}
