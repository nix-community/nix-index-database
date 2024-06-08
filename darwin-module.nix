self:
{ pkgs, lib, ... }:
{
  programs.nix-index = {
    enable = lib.mkDefault true;
    package = lib.mkDefault self.packages.${pkgs.stdenv.system}.nix-index-with-db;
  };

  _file = ./darwin-module.nix;
}
