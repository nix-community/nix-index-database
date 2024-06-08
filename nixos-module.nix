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
    programs.nix-index-database.comma.enable = lib.mkEnableOption "wrapping comma with nix-index-database and put it in the PATH";
  };


  config = {
    programs.nix-index = {
      enable = lib.mkDefault true;
      package = lib.mkDefault nix-index-with-db;
    };

    environment.systemPackages = lib.optional config.programs.nix-index-database.comma.enable comma-with-db;
  };
}
