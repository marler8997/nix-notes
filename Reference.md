
# Managing Packages

### Cleanup
```
sudo nix-collect-garbage -d
sudo nixos-rebuild switch
```

| Path                | Description        |
|---------------------|--------------------|
| /run/current-system | all nixos packages |

### List package dependencies from path:

```
nix-store -qR <path>

# List in tree form
nix-store -q --tree <path>
```

### List package referrers (opposite of dependencies)

```
nix-store -q --referrers-closure <path>
```

### List roots that are keeping a package installed

```
nix-store -q --roots <path>
```
