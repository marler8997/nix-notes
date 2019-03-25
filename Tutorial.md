
# Nix Tutorial

## Terminology

* Derivation Definition - A set of data that describes how to generate a set of files that make up an installable package. This data consists of the package name, where to download it's source, how to build it, etc.  These definitions are stored in files with the extension `.drv` and can be found in `/nix/store/*.drv`.

* Realized Derivation - A set of files generated from a derivation definition.  These files will typically represent a unit of software such as libraries, command-line tools, documentation or even large peices of software like web browsers.

## The Nix Store

This "Nix Store" is where nix stores all it's packages and the information .  It is typically located at `/nix/store`.  It contains the following types of files:

1. Derivation Definition Files

These files end in the `.drv` extension.  You can list them with `ls /nix/store/*.drv`. These files describe how to generate Realized Derivations.

2. Realized Derivations

A "Realized Derivation" is a set of files that are generated from a "Derivation Definition" file.  It can be a single file, or a directory with many files.  It's name begins with a hash of the derivation definition used to generated it.

3. What else?

Realized Derivations can have other realized derivations that they depend on.  This dependency information is stored in the nix store in a database.  This allows a realized derivation and all it's dependencies to be deployed to another machine.

Checkout the `nix-store` program in [TheTools.md](TheTools.md) to see how you can interact with it.

* Question: how do you add mirrors for the nix-store to pull pre-built realized derivations from?
