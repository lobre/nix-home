# GPG keys

## Create a master GPG key

To generate a master key, use:

```
gpg --full-generate-key
```

I usually choose a `rsa4096` key which means: 
* kind: `RSA and RSA`
* size: `4096`
* expiration: `10y`

## Create an SSH authentication subkey

The master key will have to be edited to add an authentication subkey.

```
gpg --expert --edit-key <key>

gpg> addkey
gpg> # use the below settings
gpg> quit
```

I usually choose a `ed25519` key which means: 
* kind: `ECC (set your own capabilities)`
* elliptic curve: `Curve 25519`
* capabilities: only `Authenticate`
* expiration: `10y`

Now if you want to export this key in the SSH format, use:

```
gpg --export-ssh-key <key>
```

If you want to get the keygrip to use it alongside a GPG agent, use:

```
gpg --list-key --with-keygrip <key>
```

You can also check that the GPG agent is correctly started.

```
$ echo $SSH_AUTH_SOCK
/run/user/1000/gnupg/S.gpg-agent.ssh
```

And you can list loaded keys with `ssh-add -L`. The GPG agent is using keys that are declared as exposed from the `~/.gnupg/sshcontrol` file.

## Import or export the master key

Subkeys will be included. For both formats, you will need the public key also exported for future reimports.

To export the public key, use:

```
gpg --export --armor <key> > key.pub
```

And reimport it with:

```
gpg --dearmor key.pub
gpg --import key.pub.gpg
```

### To file

To export the private key to a file use:

```
gpg --export-secret-keys <key> > secret.key
```

And reimport it with:

```
gpg --import secret.key
```

### To paper

To export the key to a printable format:

```
gpg --export-secret-key <key> | paperkey --output secret.txt
```

To note that comments in the file are not needed for a future reimport using `paperkey`. Also, the passphrase will be exported and so will be kept unchanged after a reimport.

To reimport, type the entire content of you paper key into a `secret.txt` file and use: 

```
paperkey --pubring key.pub.gpg --secrets secret.txt | gpg --import
```

Then make sure to then delete `secret.txt`.

### Trust an imported key

You should trust your own master keys as ultimate.

```
gpg --edit-key <key>

gpg> trust
```

## Use a Yubikey

To move a key from your local keyring to your Yubikey:

```
gpg --expert --edit-key <key>

gpg> keytocard
gpg> # You might have to repeat for all your keys
gpg> quit
```

The key should then not exist anymore in your local keyring as it has been moved to the key. To note that a key cannot be moved back from a Yubikey to a local keyring. If lost, it will have to be regenerated, or recreated from a paper/file version.

When moved to a Yubikey, the passphrase is only required once at import time, and then won’t be stored on the key. Instead, the Yubikey is protected using an admin PIN.
