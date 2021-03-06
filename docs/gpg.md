# GPG keys

To manage secrets, I use [gopass](https://github.com/gopasspw/gopass). It relies on GPG keys for identification and encryption. So before doing anything else, it is important to configure my GPG key pair.

## Import keys

To list available keys, use the following.

```
gpg --list-secret-keys
```

If there is no key, you should import them.

Public key is stored unencrypted in the gopass git repository. You can find it in the `.public-keys` directory at the root of the repository.

Download the public key and store it as `public.key`. Then, dearmor (text to binary) the key using this command.

```
gpg --dearmor public.key
```

This will create a `public.key.gpg`. You can then import it.

```
gpg --import public.key.gpg
```

Moving on to the private key. There are two ways to recover it.

### Paper

I usually keep a printed version as qrcodes. They should be scanned as PNG files and renamed `IMGaa.png`, `IMGab.png`, `IMGac.png`, `IMGad.png`, etc. Once you have them, here are the commands to import the key.

```
for f in IMG*.png; do zbarimg --raw $f | head -c -1 > $f.out ; done
cat *.out | base64 -d | paperkey --pubring public.key.gpg | gpg --import
```

You will be prompted to enter the passphrase, and then you should be good to go.

### Yubikey

Using a Yubikey simplifies drastically the process because you basically don’t have anything to do except plugging it when you want to use your key.

## SSH keys

Instead of having a regular OpenSSH key, I decided to also rely on GPG to authenticate to SSH services. I have created a GPG subkey which has "authentication" capabilities.

For that to work, the GPG agent is also replacing the regular SSH agent to handle the discovery and unlocking of keys. To export the public part of this authentication key in a regular SSH format, use the following command.

```
gpg --export-ssh-key key-id
```

You can also check that the GPG agent is correctly started.

```
$ echo $SSH_AUTH_SOCK
/run/user/1000/gnupg/S.gpg-agent.ssh
```

And you can list loaded keys with `ssh-add -L`. The GPG agent is using keys that are declared as exposed from the `~/.gnupg/sshcontrol` file.

## Create a PDF with your private key as QRcodes

To simplify the process, I have created a little wrapper script.

```
gpg-export key-id
```
