self:
{ config, pkgs, lib, ... }:
{
  options = {
    programs.nix-index-database.comma.enable = lib.mkEnableOption "wrapping comma with nix-index-database and put it in the PATH";
  };

  config = {
    programs.nix-index = {
      enable = lib.mkDefault true;
      package = lib.mkDefault self.packages.${pkgs.stdenv.system}.nix-index-with-db;
    };
    environment.systemPackages = lib.optional config.programs.nix-index-database.comma.enable self.packages.${pkgs.stdenv.system}.comma-with-db;
  };

  _file = ./nixos-module.nix;
}
