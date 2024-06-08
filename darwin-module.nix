{ lib,  pkgs, databases, ... }:

let
  nix-index-with-db = pkgs.callPackage ./nix-index-wrapper.nix {
    nix-index-database = databases.${pkgs.stdenv.system}.database;
  };
in

{
  programs.nix-index = {
    enable = lib.mkDefault true;
    package = lib.mkDefault nix-index-with-db;
  };
}
