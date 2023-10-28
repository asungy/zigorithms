{
  description = "Algorithms implemented in Zig.";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig.url         = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, zig } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          (final: prev: {
            zigpkgs = inputs.zig.packages.${prev.system};
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.zigpkgs.master
            pkgs.zls
          ];

          shellHook = ''
            PS1="\n\[\033[01;32m\]nix(\W) >\[\033[00m\] "
          '';
        };
      }
    );
}
