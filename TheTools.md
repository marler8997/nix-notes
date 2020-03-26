
# `nix-env`

Used to manage packages, profiles/environments.

Note that `nix-env` changes behavior depending on if you are running as a user or as root.  If you run commands as root, then it will manage a profile that is shared by all users (`/nix/var/nix/profiles/default`), but running as a non-root user will only affect that user's profile. (i.e. `sudo nix-env -iA nixos.hello` will install `hello` for all users).


```
# search for packages
nix-env -qaP '<regex>'
nix-env -qaP '.*emacs.*'

# see what packages are installed to the current user-profile
nix-env -q
# or
nix-env --query

# install a package using the top-level derivation name
nix-env -iA $CHANNEL.$PACKAGE_ATTR_NAME (Run: "[sudo] nix-channel --list" to see channels)
# i.e. on Nixos
nix-env -iA nixos.bsdgames
# i.e. with Nix as a Package Manager
nix-env -iA nixpkgs.bsdgames

# You can also use "nix-env -i package" to install a package to the user profile
# using the package "name", however, this is very very slow, so I never do it
#
# Also note that installing a library to the user-profile doesn't setup all the environment
# variables to build tools to find then, use "nix-shell -p package" for that

# erase a package from the current user-profile
nix-env -e hello
nix-env --uninstall hello

# upgrade packages
nix-env -u

nix-env --list-generations
nix-env --delete-generations <nums>...
# switch generation
nix-env -G <num>
```

# `nix-store`

Used to manage the "nix store" where nix stores all it's packages. Use it to query the store, cleanup unused packages, get dependency information.

```
# A closure is the set of all directories in the nix store to support a set of packages
# For example, if you wanted all the directories to support `nix` and `hello`, you could do
# Get a 'closure` of a set of derivations.  For example, 
nix-store -qR `which nix` `which hello`

# You can see a nice view of a closure with
nix-store -q --tree `which <tool>`

# i.e. print the closure of the current profile
nix-store -q --tree ~/.nix-profile

# garbage collection
nix-store --gc --print-roots
nix-store --gc
# note: you can also just use nix-collect-garbage
# delete a root?
# the only way I know to do this is find the link in /nix/var/nix/gcroots and unlink it
# print roots using a file in a package
nix-store -q --roots <files>...

# build a package based on it's derivation file (called "realizing a derivation")
# (this would typically be called after using nix-instantiate to generate a derivation `.drv` file)
nix-store -r /nix/store/<hash>-<name>.drv
```

# `nix-channel`

A nix channel is just a place to get derivations from.

> NOTE: on my nixos, I need to run these with sudo, even when NIX_REMOTE=daemon is set
```
nix-channel --list

# download channel updates
nix-channel --update

nix-channel --add <url> <name>

nix-channel --remove <name>
```

# `nix-instantiate`

```
nix-instantiate [--add-root] <file>.nix
```


# `nix-build`

A wrapper around `nix-instantiate` and `nix-store -r` to "instantiate" and "realize" a derivation in one command:
```
nix-build mypackage.nix
```

# `nix-shell`

```
# start a shell in the build environment for a package
nix-shell <file>.nix
```

# `nix`

```
# pretty print a derivation file
nix show-derivation /nix/store/<hash>-<name>.drv
```