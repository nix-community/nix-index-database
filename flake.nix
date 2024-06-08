{
  description = "nix-index database";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      testSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      systems = testSystems ++ [
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      mkPackages =
        pkgs:
        let
          generated = import ./generated.nix;

          nix-index-database =
            (pkgs.fetchurl {
              url = generated.url + pkgs.stdenv.system;
              hash = generated.hashes.${pkgs.stdenv.system};
            }).overrideAttrs
              {
                __structuredAttrs = true;
                unsafeDiscardReferences.out = true;
              };
        in
        {
          inherit nix-index-database;

          nix-index-with-db = pkgs.callPackage ./nix-index-wrapper.nix { inherit nix-index-database; };
          comma-with-db = pkgs.callPackage ./comma-wrapper.nix { inherit nix-index-database; };
        };
    in
    {
      packages = lib.genAttrs systems (system:
        (mkPackages nixpkgs.legacyPackages.${system}) // {
          default = self.packages.${system}.nix-index-with-db;
        }
      );

      legacyPackages = lib.warn ''
        nix-index-database's "legacyPackages" output is deprecated and will be removed
        please switch to "packages" instead
      ''
        self.packages;

      overlays.nix-index = _: mkPackages;

      darwinModules.nix-index = import ./darwin-module.nix self;

      hmModules.nix-index = import ./home-manager-module.nix self;

      nixosModules.nix-index = import ./nixos-module.nix self;

      checks = lib.genAttrs testSystems (system:
        import ./tests.nix {
          inherit system nixpkgs;
          nixIndexModule = self.nixosModules.nix-index;
        }
      );
    };
}
