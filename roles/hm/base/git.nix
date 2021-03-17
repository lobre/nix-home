{ secrets, ... }:

{
  programs.git = {
    enable = true;
    userEmail = secrets.email;
    userName = secrets.name;

    signing = {
      key = secrets.gpg.fingerprint;
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
        helper = "gopass";
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
