
## 1. Find a release

* Channel list is here: https://channels.nixos.org/
* Information about channels: https://nixos.wiki/wiki/Nix_channels

## 2. Find your current release

```
sudo nix-channel --list
```

If you have multiple channels, the one you're intereseted in is the one named "nixos".

## 2. Check "Release Notes"

https://nixos.org/manual/nixos/stable/release-notes.html

To help avoid issues, you can check all the releases between your current version
and the version you're upgrading to.

## 3. Save current release channel

```
sudo nix-channel --add http://nixos.org/channels/nixos-${CURRENT_RELEASE_VERSION} nixos-old
```

#### Example:
```
sudo nix-channel --add https://nixos.org/channels/nixos-20.03 nixos-old
```

## 4. Add the new release channel

```
sudo nix-channel --add http://nixos.org/channels/nixos-${NEW_RELEASE_VERSION} nixos
```

#### Example:
```
sudo nix-channel --add https://nixos.org/channels/nixos-21.05 nixos
```

## 5. Verify your channels look good

```
sudo nix-channel --list
```

#### Example:
```sh
$ sudo nix-channel --list
nixos https://nixos.org/channels/nixos-21.05
nixos-old https://nixos.org/channels/nixos-20.03
```

## 6. Preform the upgrade

```
sudo nixos-rebuild --upgrade boot
```

## 7. Reboot

If something goes wrong, select the previous generation, then use `nix-channel` to add the old channel and run `sudo nixos-rebuild boot` to make the working generation the default.
