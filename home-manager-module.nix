{ packages }:
{ lib, pkgs, ... }:

{
  programs.nix-index = {
    enable = lib.mkDefault true;
    package = packages.${pkgs.system}.nix-index-with-db;
  };
}
