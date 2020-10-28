{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userEmail = "loric.brevet@gmail.com";
    userName = "Loric Brevet";

    aliases = {
      "lo" = "log -i --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      "authors" = "shortlog -e -s -n";
      "sh" = "show";
      "st" = "status";
      "co" = "checkout";
      "br" = "branch";
      "ci" = "commit";
      "cp" = "cherry-pick";
      "mt" = "mergetool";
      "dt" = "difftool";
      "di" = "diff";
    };

    ignores = [
      "tags"
      "tags.lock"
      "tags.temp"
    ];

    extraConfig = {
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
        # It stores passwords in the plain ~/.git-credentials file
        # but for a single user, there is no other simple method
        # (libsecret requires X for example)
        helper = "store";
      };
      merge = {
        tool = "meld";
      };
      mergetool = {
        cmd = ''cmd = meld --auto-merge "$LOCAL" "$BASE" "$REMOTE" --output "$MERGED" --label "MERGE"'';
        trustExitCode = false;
        prompt = false;
        keepBackup = false;
      };
      diff = {
        tool = "meld";
        submodule = "log";
      };
      difftool = {
        cmd = ''meld "$LOCAL" "$REMOTE" --label "DIFF"'';
        prompt = false;
      };
      status = {
        submoduleSummary = true;
      };
      submodule = {
        recurse = true;
      };
    };

    lfs.enable = true;

    includes = [ { path = "~/.gitconfig.local"; } ];
  };
}
