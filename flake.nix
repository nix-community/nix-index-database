{
  description = "nix-index database";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/master";

  outputs = { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      systems = lib.attrNames self.legacyPackages;
      # Garnix does not currently have HW accel for aarch64-linux
      testSystems = [ "x86_64-linux" ];

      packages = lib.genAttrs systems (system: {
        default = self.packages.${system}.nix-index-with-db;
        nix-index-with-db =
          nixpkgs.legacyPackages.${system}.callPackage ./nix-index-wrapper.nix {
            nix-index-database = self.legacyPackages.${system}.database;
          };
        comma-with-db =
          nixpkgs.legacyPackages.${system}.callPackage ./comma-wrapper.nix {
            nix-index-database = self.legacyPackages.${system}.database;
          };
      });
    in
    {
      inherit packages;

      legacyPackages = import ./packages.nix;

      darwinModules.nix-index = import ./darwin-module.nix {
        inherit (self) packages;
      };

      hmModules.nix-index = import ./home-manager-module.nix {
        inherit (self) packages legacyPackages;
      };

      nixosModules.nix-index = import ./nixos-module.nix {
        inherit packages;
      };

      checks = lib.genAttrs testSystems (system:
        import ./tests.nix {
          inherit system nixpkgs;
          nixIndexModule = self.nixosModules.nix-index;
        }
      );
    };
}
