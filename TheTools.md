
# `nix-env`

Used to manage packages, profiles/environments.

```
# search for packages
nix-env -qaP '<regex>'
nix-env -qaP '.*emacs.*'

# install a package
nix-env -i hello
# install a package using the top-level derivation name
nix-env -iA nixpkgs.bsdgames

# erase a package
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