{
  description = "nix-index database";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      systems = lib.attrNames self.legacyPackages;
      testSystems = [ "x86_64-linux" "aarch64-linux" ];

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

      darwinModules.nix-index.imports = [
        ({ pkgs, ... }: {
          programs.nix-index.enable = true;
          programs.nix-index.package = packages.${pkgs.hostPlatform.system}.nix-index-with-db;
        })
      ];

      hmModules.nix-index.imports = [
        ./home-manager-module.nix
        ({ pkgs, config, ... }: {
          programs.nix-index.package = packages.${pkgs.hostPlatform.system}.nix-index-with-db;
          home.file."${config.xdg.cacheHome}/nix-index/files" = lib.mkIf config.programs.nix-index.symlinkToCacheHome {
            source = self.legacyPackages.${pkgs.hostPlatform.system}.database;
          };
        })
      ];

      nixosModules.nix-index.imports = [
        ./nixos-module.nix
        ({ pkgs, config, ... }: {
          programs.nix-index.package = lib.mkDefault packages.${pkgs.hostPlatform.system}.nix-index-with-db;
          environment.systemPackages = lib.optional config.programs.nix-index-database.comma.enable packages.${pkgs.hostPlatform.system}.comma-with-db;
        })
      ];

      checks = lib.genAttrs testSystems (system:
        import ./tests.nix {
          inherit system nixpkgs;
          nixIndexModule = self.nixosModules.nix-index;
        }
      );
    };
}
