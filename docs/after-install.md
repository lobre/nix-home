# After installation

After having installed NixOS and booted, you will want to re-clone this project in `~/lab/github.com/lobre/nix-home` and copy our `configuration.nix` and `hardware-configuration.nix` files.

```
git clone https://github.com/lobre/nix-home ~/lab/github.com/lobre/nix-home
sudo chown ${USER}:users /etc/nixos/{hardware-,}configuration.nix
sudo mv /etc/nixos/{hardware-,}configuration.nix ~/lab/github.com/lobre/nix-home/
```

Then, make sure to re-apply the configurations to see if everything works as expected. To note that we use a custom script aware of the location of our configurations.

```
sudo ~/lab/github.com/lobre/nix-home/nix-switch.sh system
```
