Chroot Nix Profile
================================================================================

## Option 1: use `mkview`

Create the view:
```
mkview view /nix ~ /proc /sys
```

Add the current directory via `.` if it's not underneath `~`.

Note: if you create the view underneath your home directory, then you'll get a circular reference and have a hard time removing the view.

```
~/ ... /view/~/ ... /view/~/  ...
```



This command includes the following directories into the view:

1. `/nix`
2. `~` so we can access `~/.nix-profile`
3. '.' current directory

WARNIING: if the current directory `.` is inside of `~`, then this will cause an issue where `rmr view` won't work because there is a circular reference. You'll need to do `sudo umount .` first.  If the current directory is underneath `~` then you don't need to add `.`.

Chroot into the view
```
inroot view <program>...
```

Remove the view
```
rmr view
```


## Option 2: Use an overlay

```
mkdir root
mount
```

Turn a profile into a "chrootable" directory:
```
mkdir ~/.nix-profile/nix
```

```
mkdir -p new-root/nix
sudo mount --bind /nix new-root/nix
```
