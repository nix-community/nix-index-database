{
  lib,
  pkgs,
  config,
  ...
}:
let
  packages = import ./. { inherit pkgs; };
in
{
  imports = [ ./nix/shared.nix ];

  programs.nix-index.package = lib.mkDefault packages.nix-index-with-db;
  programs.command-not-found.enable = lib.mkDefault false;
  environment.systemPackages = lib.mkIf config.programs.nix-index-database.comma.enable [
    packages.comma-with-db
  ];
}
