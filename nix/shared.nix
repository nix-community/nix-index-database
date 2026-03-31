{ lib, pkgs, ... }:
let
  packages = import ../. { inherit pkgs; };
in
{
  options = {
    programs.nix-index-database.comma = {
      enable = lib.mkEnableOption "wrapping comma with nix-index-database and put it in the PATH";
      package = lib.mkPackageOption packages "comma-with-db" { };
    };
  };

  config.programs.nix-index.enable = lib.mkDefault true;
}
