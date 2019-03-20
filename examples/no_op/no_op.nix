with {
  nixpkgs = import <nixpkgs> {};
};
derivation {
  name = "no-op";
  builder = "${nixpkgs.bash}/bin/bash";
  args = ["-c" "${nixpkgs.coreutils}/bin/touch $out"];
  system = builtins.currentSystem;
}
