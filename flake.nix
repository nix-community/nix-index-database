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

      apps = lib.genAttrs systems (system: {
        default =
          let
            pkgs = nixpkgs.legacyPackages.${system};
            adhocDownloadScript = pkgs.writeShellApplication {
              name = "adhoc-download";
              runtimeInputs = with pkgs; [
                wget
                bash
              ];
              text = ''
                #!/usr/bin/env bash
                filename="index-$(uname -m | sed 's/^arm64$/aarch64/')-$(uname | tr '[:upper:]' '[:lower:]')"
                mkdir -p ~/.cache/nix-index && cd ~/.cache/nix-index
                wget -q -N https://github.com/nix-community/nix-index-database/releases/latest/download/"$filename"
                ln -f "$filename" files
              '';
            };
          in
          {
            type = "app";
            program = "${lib.getExe adhocDownloadScript}";
          };
      });

      darwinModules = {
        default = self.darwinModules.nix-index;
        nix-index = ./darwin-module.nix;
      };

      hmModules.nix-index = lib.warn "nix-index-database: flake output `hmModules` has been renamed to `homeModules`" ./home-manager-module.nix;

      homeModules = {
        default = self.homeModules.nix-index;
        nix-index = ./home-manager-module.nix;
      };

      nixosModules = {
        default = self.nixosModules.nix-index;
        nix-index = ./nixos-module.nix;
      };

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
