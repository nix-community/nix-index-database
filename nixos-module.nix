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
  options.programs.nix-index-database = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable nix-index-database";
      type = lib.types.bool;
    };
    comma.enable = lib.mkEnableOption "wrapping comma with nix-index-database and put it in the PATH";
  };

  config = lib.mkIf cfg.enable {
    programs.nix-index.enable = lib.mkDefault true;
    programs.nix-index.package = lib.mkDefault packages.nix-index-with-db;
    programs.command-not-found.enable = lib.mkDefault false;
    environment.systemPackages = lib.mkIf cfg.comma.enable [
      cfg.comma.package
    ];
  };
}
