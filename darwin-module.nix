{ databases }:
{ pkgs, ... }:

let
  nix-index-with-db = pkgs.callPackage ./nix-index-wrapper.nix {
    nix-index-database = databases.${pkgs.stdenv.system}.database;
  };
in

{
  programs.nix-index.enable = true;
  programs.nix-index.package = nix-index-with-db;
}
