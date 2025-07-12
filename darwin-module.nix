self:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  packages = pkgs.callPackage self { };
in
{
  imports = [ ./nix/shared.nix ];

  programs.nix-index.package = lib.mkDefault packages.nix-index-with-db;
  environment.systemPackages = lib.mkIf config.programs.nix-index-database.comma.enable [
    packages.comma-with-db
  ];

  _file = ./darwin-module.nix;
}
