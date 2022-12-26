{
  description = "nix-index database";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }: with nixpkgs.lib;
    let
      systems = attrNames self.legacyPackages;

      packages = genAttrs systems
        (system: {
          nix-index-with-db =
            nixpkgs.legacyPackages.${system}.callPackage ./nix-index-wrapper.nix {
              nix-index-database = self.legacyPackages.${system}.database;
            };
        });
    in
    {
      inherit packages;

      legacyPackages = import ./packages.nix;

      hmModules.nix-index = import ./home-manager-module.nix {
        inherit packages;
      };

      nixosModules.nix-index = import ./nixos-module.nix {
        inherit packages;
      };
    };
}
