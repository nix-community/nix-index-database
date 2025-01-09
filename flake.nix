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

      mkPackages = pkgs: import ./default.nix { inherit pkgs; };
    in
    {
      packages = lib.genAttrs systems (
        system:
        (mkPackages nixpkgs.legacyPackages.${system})
        // {
          default = self.packages.${system}.nix-index-with-db;
        }
      );

      legacyPackages = builtins.mapAttrs (
        systemName: systemPackages:
        builtins.mapAttrs (
          name: pkg:
          lib.warn ''
            nix-index-database's "legacyPackages.${systemName}.${name}" output is deprecated and will be removed
            please switch to "packages.${systemName}.${name}" instead
          '' pkg
        ) systemPackages
      ) self.packages;

      overlays.nix-index = final: _prev: mkPackages final;

      darwinModules.nix-index = import ./darwin-module.nix self;

      hmModules.nix-index = import ./home-manager-module.nix self;

      nixosModules.nix-index = import ./nixos-module.nix self;

      checks = lib.genAttrs testSystems (
        system:
        import ./tests.nix {
          inherit system nixpkgs;
          nixIndexModule = self.nixosModules.nix-index;
        }
      );

      formatter = lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
