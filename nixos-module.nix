{ packages }:
{ config, pkgs, lib, ... }: {
  options = {
    programs.nix-index-database.comma.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to wrap comma with nix-index-database and put it in the PATH.";
    };
  };

  config = {
    programs.nix-index.enable = lib.mkDefault true;
    programs.nix-index.package = lib.mkDefault packages.${pkgs.stdenv.system}.nix-index-with-db;
    environment.systemPackages = lib.optional config.programs.nix-index-database.comma.enable 
      packages.${pkgs.stdenv.system}.nix-index-with-db;
  };
}
