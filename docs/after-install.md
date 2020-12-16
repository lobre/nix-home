# After installation

After having installed NixOS and booted, you will want to re-clone this project in `~/Lab/nix-home` and copy our `configuration.nix` and `hardware-configuration.nix` files.

```
git clone https://github.com/lobre/nix-home ~/Lab/nix-home
sudo chown ${USER}:users /etc/nixos/{hardware-,}configuration.nix
sudo mv /etc/nixos/{hardware-,}configuration.nix ~/Lab/nix-home/
```

Then, make sure to re-apply the configurations to see if everything works as expected. To note that we use a custom script aware of the location of our configurations.

```
sudo ~/Lab/nix-home/nix-switch system
```
