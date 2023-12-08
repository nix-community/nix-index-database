{ config, pkgs, lib, databases, ... }:

let
  nix-index-with-db = pkgs.callPackage ./nix-index-wrapper.nix {
    nix-index-database = databases.${pkgs.stdenv.system}.database;
  };
  comma-with-db = pkgs.callPackage ./comma-wrapper.nix {
    nix-index-database = databases.${pkgs.stdenv.system}.database;
  };
in

{
  options = {
    programs.nix-index-database.comma.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to wrap comma with nix-index-database and put it in the PATH.";
    };
  };

  config = {
    programs.nix-index.enable = lib.mkDefault true;
    programs.nix-index.package = lib.mkDefault nix-index-with-db;
    environment.systemPackages = lib.optional config.programs.nix-index-database.comma.enable comma-with-db;
  };
}
