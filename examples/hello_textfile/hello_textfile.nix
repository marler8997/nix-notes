with {
  nixpkgs = import <nixpkgs> {};
};
derivation {
  name = "hello-world";
  builder = "${nixpkgs.bash}/bin/bash";
  args = [./install.sh];
  textfile = ./hello.txt;
  coreutils = nixpkgs.coreutils;
  system = builtins.currentSystem;
}
