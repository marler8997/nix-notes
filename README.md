# My Documents

* [Tutorial](Tutorial.md)
* [How to use Nix as a Package Manager](How-to-use-Nix-as-a-Package-Manager.md)
* [Chroot Nix Profile](Chroot-Nix-Profile.md)
* [NixOS](NixOS.md)
* [Syntax](Syntax.md)

# Nix Pills

A good set of starting documents to "learn the ropes" of nix.

https://nixos.org/nixos/nix-pills

# Manuals

These documents are long. Good for reference, not good for learning.

* The Nix Manual: https://nixos.org/nix/manual/
* The Nixpkgs Manual: https://nixos.org/nixpkgs/manual/
* The NixOS Manual: https://nixos.org/nixos/manual/

* Common operations Cheatsheet: https://nixos.wiki/index.php?title=Cheatsheet&useskin=vector
  The above link also shows equivalent operations between Ubuntu and Nix.

# More Reading

The author of the "Nix Pills" listed above did his thesis on Nix.  It's a good read about where current software deployment systems lack and how Nix has solved alot of the problems they have: https://nixos.org/~eelco/pubs/phd-thesis.pdf

# Questions

* Can a profile be defined with a nix expression?

# Managine private nix packages outside of nixpkgs

http://sandervanderburg.blogspot.com/2014/07/managing-private-nix-packages-outside.html

# Nix Wants

* The Nix expression language is extremely powerful and extensible.  However, I find there's a lack of documentation for functions that have been implemented in nixpkgs.  I think the lack of documentation could be mitigated by adding support for a standard form for "in-source documentation".  This would encourage maintainers to provide good documentation and help keep it in sync with the implementation, though, it does not guarantee it.
