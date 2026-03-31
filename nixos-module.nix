{
  lib,
  pkgs,
  config,
  ...
}:
let
  packages = import ./. { inherit pkgs; };
  cfg = config.programs.nix-index-database;
in
{
  imports = [ ./nix/shared.nix ];

  programs.nix-index.package = lib.mkDefault packages.nix-index-with-db;
  programs.command-not-found.enable = lib.mkDefault false;
  environment.systemPackages = lib.mkIf cfg.comma.enable [
    cfg.comma.package
  ];
}
