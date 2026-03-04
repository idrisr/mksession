{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem
      [ "x86_64-linux" "aarch64-darwin" ]
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          mksession = pkgs.haskellPackages.callPackage ./default.nix { };
        in
        {
          packages.default = mksession;
          checks.default = mksession;

          devShells.default = pkgs.mkShell {
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.zlib ];
            buildInputs = with pkgs.haskellPackages; [
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
        }) //
    {
      overlays.default = final: prev: {
        mksession =
          final.haskell.packages.ghc984.callPackage ./default.nix { };
      };
    }
  ;
}
