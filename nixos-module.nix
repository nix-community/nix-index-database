{ legacyPackages }:
{ config, pkgs, inputs, ... }: {
  environment.systemPackages = [
    (pkgs.callPackage ./nix-index-wrapper.nix {
      nix-index-database = legacyPackages.${pkgs.hostPlatform.system}.database;
    })
  ];
}
