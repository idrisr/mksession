{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        compiler = "ghc984";

        mksession = pkgs.haskell.packages.${compiler}.callPackage ./default.nix { };
      in
      {
        packages.default = mksession;
        checks.default = mksession;
        overlays = final: prev: { mksession = final.haskell.packages.${compiler}.callPackage ./default.nix { }; };

        devShells.default = pkgs.mkShell {
          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.zlib ];
          buildInputs = with pkgs.haskell.packages.${compiler}; [
            ghc
            cabal-install
            ghcid
            fourmolu
            cabal-fmt
            implicit-hie
            cabal2nix
            pkgs.ghciwatch
            pkgs.haskell-language-server
            pkgs.zlib
            pkgs.colordiff
          ];
        };
      });
}
