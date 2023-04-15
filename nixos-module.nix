{ packages }:
{ pkgs, lib, ... }: {
  programs.nix-index.enable = lib.mkDefault true;
  programs.nix-index.package = lib.mkDefault packages.${pkgs.stdenv.system}.nix-index-with-db;
}
