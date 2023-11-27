{
  description = "nix-index database";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      systems = lib.attrNames self.legacyPackages;
      testSystems = [ "x86_64-linux" "aarch64-linux" ];

      databases = import ./packages.nix;

      packages = lib.genAttrs systems (system: {
        default = self.packages.${system}.nix-index-with-db;
        nix-index-with-db =
          nixpkgs.legacyPackages.${system}.callPackage ./nix-index-wrapper.nix {
            nix-index-database = databases.${system}.database;
          };
        comma-with-db =
          nixpkgs.legacyPackages.${system}.callPackage ./comma-wrapper.nix {
            nix-index-database = databases.${system}.database;
          };
      });
    in
    {
      inherit packages;

      legacyPackages = import ./packages.nix;

      darwinModules.nix-index = import ./darwin-module.nix {
        inherit databases;
      };

      hmModules.nix-index = import ./home-manager-module.nix {
        inherit databases;
      };

      nixosModules.nix-index = import ./nixos-module.nix {
        inherit databases;
      };

      checks = lib.genAttrs testSystems (system:
        import ./tests.nix {
          inherit system nixpkgs;
          nixIndexModule = self.nixosModules.nix-index;
        }
      );
    };
}
