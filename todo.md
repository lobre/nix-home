# structure improvements

At the root of the repository, `home.nix` should corresponds to non-NixOS systems.
For NixOS, home-manager will be called using the home-manager module.

Entrypoints for NixOS systems will be in the `./machines/` directory.


They will look something like:

```
{ config, pkgs, ... }:
let
  secrets = import ../../secrets.nix;
  home = import ./modules/home;
  system = import ./modules/system;
in
{
  kimsufi = import ./machines/kimsufi/configuration.nix { inherits config pkgs secrets home system };
  laptop = import ./machines/laptop/configuration.nix { inherits config pkgs secrets home system };
}
```

We can take example on https://github.com/qjcg/nix/blob/master/configuration-example.nix for the syntax.

Those two folders `./modules/home` and `./modules/system` would be the dynamic shared configurations and will be available as NixOS/home-manager modules. They will bring sane defaults, and options for configurations that need to be enabled/disabled. The naming of those modules is not final. Not sure what good names would be. I also need to check if I can import/pass them as parameter like in the above example.

To finish, we will refactor the `./nix-switch.sh` script so it becomes a little bit smarter. It should recognize if the system is NixOS or not. If not, it should only call the home-manager command with `./home.nix`. Otherwise, it should call `nixos-rebuild switch` with `./configuration.nix` and use the current hostname to select the correct first-level attribute. This script will always be called as the current user and it will use `sudo` underneath if needed.

We should never explicitly import a nix file, but instead import a folder and make use of `default.nix`.

Nothing to do with the general structure, but we need a way to use a different default ssh key when at work. Maybe tweaking in `~/.ssh/config` with `IdentityFile`. Note that we are not using `programs.ssh.enable` in home manager. This might help as today, `ssh` does not come from user space configuration.


Here is the file hierarchy that I would like to establish.

.
├── home.nix
├── machines
│   ├── kimsufi
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── laptop
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── roles
│   ├── hm
│   │   ├── base
│   │   │   ├── default.nix
│   │   │   ├── git.nix
│   │   │   ├── go.nix
│   │   │   ├── shell.nix
│   │   │   ├── tmux.nix
│   │   │   └── vim.nix
│   │   └── xfce
│   │       ├── default.nix
│   │       ├── panel.nix
│   │       ├── terminal.nix
│   │       ├── wallpaper.jpg
│   │       └── xfconf.nix
│   └── nixos
│       ├── base
│       │   ├── default.nix
│       │   └── users.nix
│       └── x11
│           └── default.nix
├── secrets.nix
└── switch.sh
