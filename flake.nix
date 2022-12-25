{
  description = "nix-index database";
  outputs = _: let
    legacyPackages = import ./packages.nix;
  in {
    inherit legacyPackages;

    hmModules.nix-index = import ./home-manager-module.nix {
      inherit legacyPackages;
    };
    nixosModules.nix-index = import ./nixos-module.nix {
      inherit legacyPackages;
    };
  };
}
