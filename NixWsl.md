# Nix for WSL (Windows Subsystem for Linux)


### Create the rootfs

> If you don't already have nix installed, run `curl https://nixos.org/nix/install | sh` to install it and then `source ~/.nix-profile/etc/profile.d/nix.sh` to provide access to it in the current shell.

```
cd <some-directory>

mkdir -p etc bin usr/bin root

nix-env --profile root/.nix-profile -iA nixpkgs.coreutils nixpkgs.bash nixpkgs.nix nixpkgs.which nixpkgs.gnutar
# Note: if you want any extra packages feel free to also install them now to the profile

# This next command will limit access only to the tools we installed to our nix profile.
# You may want to start a new shell here so you can easily revert back to your original
# environment by running `exit`.
export PATH=$(realpath -s root/.nix-profile/bin)

cp -P `which sh` bin/sh
cp -P `which env` usr/bin/env

echo "root::0:0:root:/root:/bin/sh" > etc/passwd
chmod 0644 etc/passwd
echo "export PATH=/root/.nix-profile/bin" > etc/profile

# Create the list of files we need in our tar
nix-store -qR root/.nix-profile > files
echo bin >> files
echo usr >> files
echo etc >> files
echo root >> files

# tar up the files
cat files | xargs tar c > rootfs.tar
gzip rootfs.tar
```

# Create and use an executable to register your distro

At this point we have a `rootfs.tar.gz` file, but need an executable to register our distro with WSL. Here are 3 projects that can generate executables for this:

* https://github.com/Microsoft/WSL-DistroLauncher
* https://github.com/yuk7/wsldl
* https://github.com/marler8997/wsl-register

Once you have an executable, copy your register executable to the directory where you would like your distro to reside on your filesystem (i.e. `c:\linux\nix`).  This is the directory that WSL will extract your rootfs to, it must remain as long as you're distro is registered.

Now just follow the directions of the "launcher" you have chosen to register your distro.  Once the launcher has "registered" your rootfs, it should will have created a folder in your distro folder called "rootfs" with your extracted rootfs.  You can verify your distro was registered with:
```
wsl -l
# or older versions of Windows 10
wslconfig /l
```

The launcher you chose may provide support to launch a shell in your distro, or, if you have a new enough version of Windows 10 you can enter it with:
```
wsl -d <distro-name>

# or
wsl -d <distro-name> -u <user>
```

# TODO: section about adding a non-root user

## Issues

For some reason I can't install nix on Ubuntu 16.04 in WSL.  When I run `curl https://nixos.org/nix/install | sh` I get this error:
```
error: cloning builder process: Invalid Argument
error: unable to start build process
```

# Alpine WSL (doesn't work)

With the Alpine rootfs I downloaded from the website, I couldn't switch to the non-root user I created.  However with the alpine rootfs from the microsoft store, I was able to add a user and switch to it, however,wget doesn't support https behind a proxy.  It doesn't use the HTTP CONNECT function when downloading https resource, so it doesn't work.

## Make sure you are running as a non-root user:
```
# User or add a non-root user
addgroup -S <USER>
adduser -SD -s /bin/ash -G <USER> <USER>

apk add sudo
echo "<USER> ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

exit
```
Restart the session with `wsl -d Alpine -u <USER>`

## Install Nix
```
# NOTE: I've stopped here since I couldn't get the next command to work behind a proxy
sudo apk add curl
```
