Contains some example derivations:

You can instantiate them with
```
nix-instantiate <file>.nix
```
> NOTE: add the `--add-root` option to make it a root

This will create a derivation file in the nix store `/nix/store/<hash>-<name>.drv`.  Pretty print it with
```
nix show-derivation /nix/store/<hash>-<name>.drv
```

To "realize" (or "build") the package, run
```
nix-store -r /nix/store/<hash>-<name>.drv
```

As a shortcut, you can instantiate and realize a derivation with:
```
nix-build <file>.nix
```

However, this will also make the nix derivation/realization a "root" by putting symbolic links in `/nix/var/nix/gcroots/auto`.
