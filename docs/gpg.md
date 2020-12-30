# GPG keys

To manage secrets, I use [gopass](https://github.com/gopasspw/gopass). It relies on GPG keys for identification and encryption. So before doing anything else, it is important to configure my GPG key pair.

To list available keys, use the following.

```
gpg --list-secret-keys
```

If there is no key, you should import it. Public key is stored unencrypted in the gopass repository. You can find it in the `.public-keys` directory at the root of the repository. Private key is kept printed as a qrcode. It should be scanned. Once you have them, here is the process to import them.

Download the public key and store it as `public.key`. Then, dearmor the public key using this command.

```
gpg --dearmor public.key
```

This will create a `public.key.gpg`.

Then, use the following command to import the private key from the png file.

```
zbarimg -1 --raw -Sbinary secret-key.qr.png | paperkey --pubring public.key.gpg | gpg --import
```

You will be prompted to enter the passphrase, and the key should then be correctly imported.

## Create the qrcode version of private key

Here is the command you should use.

```
gpg --export-secret-key key-id | paperkey --output-type raw | qrencode --8bit --output secret-key.qr.png
```
