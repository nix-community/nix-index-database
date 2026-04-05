{
  system,
  nixpkgs,
  nixIndexModule,
  nixIndexOverlay,
}:
{
  nixosTest = nixpkgs.lib.nixos.runTest {
    name = "nix-index-nixos-test";
    imports = [
      {
        nodes = rec {
          node1 =
            { pkgs, ... }:
            {
              imports = [
                nixIndexModule
                {
                  programs.command-not-found.enable = false;

                  programs.nix-index-database.comma.enable = true;
                  # Point comma at our nixpkgs instance.
                  # Passing --nixpkgs-flake instead seems to fail when nix tries to use the network.
                  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
                  # Add ripgrep to the store so that comma can find it
                  virtualisation.additionalPaths = [ pkgs.ripgrep ];
                }
              ];
              nixpkgs.overlays = [ nixIndexOverlay ];
            };
          node2 =
            { pkgs, ... }:
            {
              imports = [
                node1
                {
                  nixpkgs.overlays = [ nixIndexOverlay ];
                  programs.nix-index-database.comma.package = pkgs.comma-with-db.override {
                    inherit (pkgs) nix-index-database;
                  };
                }
              ];
            };
        };
        testScript = ''
          start_all()

          # Check that nix-locate works
          node1.succeed(" | ".join([
            "nix-locate --whole-name --at-root '/bin/rg'",
            "cut -d' ' -f1",
            "grep -F 'ripgrep.out'"
          ]))
          node2.succeed(" | ".join([
            "nix-locate --whole-name --at-root '/share/man/man1/rg.1'",
            "cut -d' ' -f1",
            "grep -F 'ripgrep.out'"
          ]))

          # Check that comma works
          node1.fail("rg --help")
          node2.fail("rg --help")
          node1.succeed(", rg --help")
          node2.succeed(", rg --help")
        '';
      }
    ];
    hostPkgs = nixpkgs.legacyPackages.${system};
  };
}
