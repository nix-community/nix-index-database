{ packages }:
{ pkgs, ... }: {
  programs.nix-index.enable = true;
  programs.nix-index.package = packages.${pkgs.stdenv.system}.nix-index-with-db;
}
