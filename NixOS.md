
Open `/etc/nixos/configuration.nix`.

Add a non-root user:
```
users.users.<name> = {
  isNormalUser = true;
  home = "/home/<name>";
  createHome = true;
  extraGroups = ["wheel" "networkmanager"];
};
```

Reload config with:
```bash
nixos-rebuild switch
```

Not sure why, but for some reason, you need to run this command to create the `~/.nix-defexpr` symlink to allow the new user to run nix commands:
```bash
su - <user> -c "true"
```

My NixOS Install
================================================================================
* Boot with CD

* I use legacy MBR, because it's simple and it works
```
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MiB -4GiB
parted /dev/sda -- mkpart primary linux-swap -4GiB 100%
```
* Make filesystem and swap
```
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
```
* Install NixOS to disk
```
mount /dev/sda1 /mnt
swapon /dev/sda2
nixos-generate-config --root /mnt
```
* Customize installation
```
nano /mnt/etc/nixos/configuration.nix
```

Enable grub:
```
# Uncomment this line
boot.loader.grub.device = "/dev/sda";
```

Add non-root user:
```
  users.users.myNewUser = {
    isNormalUser = true;
    home = "/home/myNewUser";
    createHome = true;
    extraGroups = ["wheel" "networkmanager"];
  };
```

Add emacs:
```
  environment.systemPackages = with pkgs; [
    emacs
  ];
```

* Perform the installation
```
nixos-install
```

* Reboot
```
poweroff
```
Remove CD, then power on again.

* Remove passwords
```
passwd -d <user>
passwd -d root
passwd -d myNewUser
```

* Login to user
```
exit
# then enter login credentials
```

* TODO: allow sudo without password?
* TODO: download profiles from online repo
