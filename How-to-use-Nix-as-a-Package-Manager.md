How to use Nix as a Package Manager
===============================================================================

## Questions

Question: how to you download a profile that you've configured from somewhere online?  Probably need to add a channel and install your profile from that channel.


### Install
```
curl https://nixos.org/nix/install | sh
```

This will install nix to `/nix` and create the symbolic link `~/.nix-profile` to point to a profile somewhere in `/nix`.

### Uninstall (completely)
```
# remove 'source .../nix.sh' from ~/.profile or ~/.bash_profile if you added it
rm -rf ~/{.nix-channels,.nix-defexpr,.nix-profile,.config/nixpkgs}
sudo rm -rf /nix
```

### Activate nix profile
This will setup your `PATH` to have access to all nix packages in the current profile.
```
source ~/.nix-profile/etc/profile.d/nix.sh
```

## Overview

Activate the environment for `nix` with
```bash
source ~/.nix-profile/etc/profile.d/nix.sh
```

If `~/.nix-profile` doesn't exist, you can look for profiles in the standard location that have nix in them with:
```bash
find -L /nix/var/nix/profiles -wholename '*/profile/etc/profile.d/nix.sh'
```

Double check that `~/.nix-profile` has been created with
```bash
readlink ~/.nix-profile
```

> NOTE: realink will not work if you type `~/.nix-profile/` instead of `~/.nix-profile`

You should now have access to tools like `nix`, `nix-env`, `nix-shell`, etc.

## Profiles

A "Nix Profile" is a set of software packages.  They are implemented with tree of symbolic links pointing to the "nix store", i.e.

```
...nix-profile.../bin/bash      -> /nix/store/<hash>-bash/bin/bash
...nix-profile.../lib/libc.so.1 -> /nix/store/<hash>-libc/lib/libc.so.1
```

Command-line programs can be made available by adding `<nix-profile>/bin` to your `PATH`.


The `nix-env` tool is used to manipulate profiles.  Any packages you install/erase only affect the current profile.  Profiles have snapshots called "generations".  A new generation is created whenever a change is made and profiles can switch freely between switch generations to roll back changes.

The current profile is accessed with `~/.nix-profile`.  This is a symbolic link to the nix store containing symbolic links to other places in the store to expose the software.  The standard location for profiles is in `/nix/var/nix/profiles` but they can actually be anywhere.  Programs from the nix profile are added to the `PATH` by adding `~/.nix-profile/bin` to `PATH`, something that is done when running `source ~/.nix-profile/etc/profile.d/nix.sh`.

### Why `~/.nix-profile` ?

`~/.nix-profile` is typically a symbolic link to a file called `profile` which itself is another symbolic link that eventually goes to the nix store.
```
~/.nix-profile -> <profile-path>/profile
<profile-path>/profile -> ...eventually gets to the nix store...
```

Note that what's added to `PATH` is `~/.nix-profile/bin` rather than `<profile-path>/profile/bin`.  `PATH` is an environment variable that is passed to each process that can't be modified once a process has been started.  So `~/.nix-profile` provides a way to switch the nix profile for all processes for the current user even after they've been started, simply by changing `~/.nix-profile` to point to a different profile.

### Profiles Under the Hood

Nix provides a location for profiles in `/nix/var/nix/profiles`. My installation contains a subdirectory "per-user/<user-name>".

The contents of the profile directory are:

* 1 entry for each profile generation "profile-<gen>-link"
  these entries are symbolic links that point to the nix-store where the profile
  directories exist (i.e. bin/etc/lib/include/...).  For example, you'll find all
  the programs int the profile in the corresponding `bin` directory.
* 1 entry called "profile" that links to the current profile generation

* 1 entry for each channel generation "channels-<gen>-link"
  these entries are symbolic links that point to the nix-store where the channel
  configuration files exist (i.e. manifest.nix/binary-caches/nixpkgs)
* 1 entry called "channels" that links to the current channel generation

The profile includes a set of programs that can be run from `PATH`.  However, if you switch profiles you can't "reach" into each process's environment variables and change their path.  So, nix uses the symbolic link `~/.nix-profile` to point to the current profile.  So we add `~/.nix-profile/bin` to the `PATH` and now when we change the symbolic link all processes will have the new environment

### Manage Packages

Install package to current profile:
```
nix-env -i <package>
```

Uninstall/Erase package from current profile:
```
nix-env -e <package>
```

Upgrade a package in the current profile:
```
nix-env -u <package>
```

Show all packages installed to the current profile:
```
nix-env -q
```

Show all "available" packages that can be installed:
```
nix-env -qa
```

Note that these commands can be applied to other profiles with the `--profile <profile-link>` switch. For example, this will install the `gcc` package to the `/nix/var/nix/profiles/my-build-profile/profile` profile:
```
nix-env --profile /nix/var/nix/profiles/my-build-profile/profile -i gcc
```

#### Upgrade all packages in current profile:
```
# Note: you can optionally update the channel first
nix-channel --update nixpkgs
# This will upgrade all packages to the latest on the channel
nix-env -u '*'
```

## Manage profiles

A profile consists of a symbolic link called "profile" that points back to the nix store that contains links to all the software files for that profile.  In the directory where this "profile" link lives, it will also have a set of links for each "generation" of that profile, i.e.

```
<profile-path>/profile           ->   profile-<current-gen>-link
<profile-path>/profile-1-link    ->   /nix/store/...
<profile-path>/profile-2-link    ->   /nix/store/...
<profile-path>/profile-3-link    ->   /nix/store/...
```

This `profile-path` can be anywhere.  Nix does have a standard location for them as well:
```
/nix/var/nix/profiles
```

You can list all the profiles in the standard location with:
```bash
find /nix/var/nix/profiles/ -name profile
```

#### Create a profile:

Profiles are automatically created when you switch to them with `nix-env --switch-profile <profile-link>`, however, it's important to know whether or not the nix tools will be available inside that profile.  If you are not on NixOS, chances are you are using the "nix package" inside a nix profile to access nix tools like "nix-env". So if you want to have access to the nix tools inside the new profile, you'll need to install them to the new profile before switching to it. You can do this with:
```bash
# add the 'nix' package to the new profile so we have access to nix
# after we switch profiles
nix-env --profile <profile-link> -i nix

nix-env --switch-profile <profile-link>
```

Try this example:
```bash
# save current profile
OLD_PROFILE=$(readlink ~/.nix-profile)

# verify old profile was saved
$OLD_PROFILE/bin/nix-env --version

mkdir custom-profile

# install nix to new profile
nix-env --profile custom-profile/profile -i nix

# switch to the new profile
nix-env --switch-profile custom-profile/profile

# verify nix is still working
nix-env --version

# switch back to the old profile
nix-env --switch-profile $OLD_PROFILE
```

If you don't want to install the nix package in the new profile, you can save a reference to the old profile like in the example above and run this to switch back:

```bash
$OLD_PROFILE/bin/nix-env --switch-profile $OLD_PROFILE
```

#### Generations

A generation is a snapshot of a profile.  Each time a change is made a new generation is created.

List generations
```
nix-env --list-generations
```

Go to previous generation:
```
nix-env --rollback
```

Go to specific generation
```
nix-env --switch-generation <num>
nix-env -G <num>
```
> NOTE: there should be a convenient way to switch to the latest generation

Delete generation
```
nix-env --delete-generations <nums>...
```

## Temporary Profile

The following will start a new shell with the given packages:
```
nix-shell -p <package>
```


# Create an isolated environment

```
mkdir <profile-dir>
nix-env --profile <profile-dir>/profile -i <packages>...

# start a new shell so we can revert to the previous profile
# by simply running 'exit'
bash
export PATH=<profile-dir>/profile/bin

# Now in Isolated Environment...

# Revert back
exit

# Cleanup isolated environment
rm -rf <profile-dir>
```

### Example
```
cd /tmp
mkdir temp_profile
nix-env --profile temp_profile/profile -i bash hello
bash
export PATH=temp_profile/profile/bin

# Now in Isolated Environment..

# Revert back
exit

# Cleanup
rm -rf temp_profile
```


### TODO: more usages of nix-shell
