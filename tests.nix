{ system, nixpkgs, nixIndexModule }:
{
  nixosTest = nixpkgs.lib.nixos.runTest {
    name = "nix-index-nixos-test";
    imports = [{
      nodes = {
        node1 = { pkgs, ... }: {
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
        };
      };
      testScript = ''
        start_all()

        # Check that nix-locate works
        node1.succeed(" | ".join([
          "nix-locate --top-level --whole-name --at-root '/bin/rg'",
          "cut -d' ' -f1",
          "grep -F 'ripgrep.out'"
        ]))

        # Check that comma works
        node1.fail("rg --help")
        node1.succeed(", rg --help")
      '';
    }];
    hostPkgs = nixpkgs.legacyPackages.${system};
  };
}
