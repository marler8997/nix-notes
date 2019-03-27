
Use `nixos-generatos` to build a base image
================================================================================
```
git clone https://github.com/Luis-Hebendanz/nixos-generators
```

My NixOS Install
================================================================================
* [VIRTUALBOX WARNING] Do not use the `VMSVGA` graphics controller.  Switch to `VBoxSvga`.

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
    nix-index # used to find nix packages by file
    gitFull # need Full for git gui
    emacs
  ];
```

Set timezone:
```
  # Uncomment and modify this line
  time.timeZone = "America/Boise";
```

For VirtualBox add the following in hardware-configuration.nix
```
  boot.initrd.checkJournalingFS = false;
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

### Do the following as root

* (Optional) Remove passwords
```
passwd -d <user>
passwd -d root
passwd -d myNewUser
```

* (Optional) Allow user to sudo without password
`/etc/nixos/configuration.nix`
```
  security.sudo.extraConfig = ''
    <MY-USER> ALL=(ALL) NOPASSWD: ALL
  '';
```

* (Optional) Enable ssh server
Uncomment from `/etc/nixos/configuration.nix`:
```
  services.openssh.enable = true;
```
Add this line to enable x11 forwarding:
```
  services.openssh.forwardX11 = true;
```

* (Optional) Virtual Box Share

> NOTE: I haven't tried this
```
  fileSystems."/virtualboxshare" = {
    fsType = "vboxsf";
    device = "nameofthesharedfolder";
    options = ["rw"];
  };
```

* Login to user
```
exit
# then enter login credentials
```

* TODO: download profiles from online repo

### VirtualBox Extras
Add this to `/etc/nixos/hardware-configuration.nix`:
```
  virtualisation.virtualbox.guest.enable = true;
```

Notes
================================================================================
Any time you make changes to the system config, apply those changes with:
```bash
nixos-rebuild switch
```

Not sure why, but for some reason, you need to run this command to create the `~/.nix-defexpr` symlink to allow the new user to run nix commands:
```bash
su - <user> -c "true"
```

The X Window System
================================================================================
I can't figure out how to increase resolution on VirtualBox without using xserver with a desktop-manager.

Add this to `/etc/nixos/configuration.nix`:
```
  imports = [
    ...
    ./xwindows.nix
  ];
```

Then create and add this to `/etc/nixos/xwindows.config`:
```
{ config, lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    autorun = true;
    desktopManager.xfce.enable = true;
  };
}
```

Run `nixos-rebuild switch` then reboot.  You should boot into an X session.

You can change resolution from virtualbox by clicking "View > Virtual Screen > Resize NxN"
