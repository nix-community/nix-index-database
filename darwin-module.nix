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

  options.programs.nix-index-database = {
    package = lib.mkPackageOption packages "nix-index-with-db" { };
  };

  config = {
    programs.nix-index.package = lib.mkDefault config.programs.nix-index-database.package;
    environment.systemPackages = lib.mkIf config.programs.nix-index-database.comma.enable [
      packages.comma-with-db
    ];
  };
}
