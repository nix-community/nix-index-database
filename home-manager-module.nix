{ legacyPackages }:
{ config, pkgs, inputs, ... }:

{
  home.packages = [
    (pkgs.callPackage ./nix-index-wrapper.nix {
      nix-index-database = legacyPackages.${pkgs.hostPlatform.system}.database;
    })
  ];
}
