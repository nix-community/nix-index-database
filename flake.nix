{
  description = "nix-index database";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      systems = lib.attrNames self.legacyPackages;
      testSystems = [ "x86_64-linux" "aarch64-linux" ];

      databases = import ./packages.nix;

      mkPackages = pkgs: {
        nix-index-with-db =
          pkgs.callPackage ./nix-index-wrapper.nix {
            nix-index-database = databases.${pkgs.stdenv.system}.database;
          };
        comma-with-db =
          pkgs.callPackage ./comma-wrapper.nix {
            nix-index-database = databases.${pkgs.stdenv.system}.database;
          };
      };
    in
    {
      packages = lib.genAttrs systems (system:
        (mkPackages nixpkgs.legacyPackages.${system}) // {
          default = self.packages.${system}.nix-index-with-db;
        }
      );

      legacyPackages = import ./packages.nix;

      overlays.nix-index = final: prev: mkPackages final;

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
