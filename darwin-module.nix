self:
{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [ ./nix/shared.nix ];

  programs.nix-index.package = lib.mkDefault self.packages.${pkgs.stdenv.system}.nix-index-with-db;
  environment.systemPackages = lib.mkIf config.programs.nix-index-database.comma.enable
    [ self.packages.${pkgs.stdenv.system}.comma-with-db ];

  _file = ./darwin-module.nix;
}
