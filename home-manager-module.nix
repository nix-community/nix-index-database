{ packages, legacyPackages }:
{ lib, pkgs, config, ... }:

{
  options = {
    programs.nix-index.symlinkToCacheHome = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to symlink the prebuilt nix-index database to the default
        location used by nix-index. Useful for tools like comma.
      '';
    };
    programs.nix-index-database.comma.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to wrap comma with nix-index-database and put it in the PATH.
      '';
    };
  };
  config = {
    programs.nix-index = {
      enable = lib.mkDefault true;
      package = packages.${pkgs.stdenv.system}.nix-index-with-db;
    };
    home.packages = lib.optional config.programs.nix-index.enable packages.${pkgs.stdenv.system}.comma-with-db;

    home.file."${config.xdg.cacheHome}/nix-index/files" =
      lib.mkIf config.programs.nix-index.symlinkToCacheHome
        { source = legacyPackages.${pkgs.stdenv.system}.database; };
  };
}
