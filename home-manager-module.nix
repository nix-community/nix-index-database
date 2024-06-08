{ lib, pkgs, config, databases, ... }:

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
    programs.nix-index.symlinkToCacheHome = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.nix-index.enable;
      description = ''
        Whether to symlink the prebuilt nix-index database to the default
        location used by nix-index. Useful for tools like comma.
      '';
    };
    programs.nix-index-database.comma.enable = lib.mkEnableOption "wrapping comma with nix-index-database and put it in the PATH";
  };

  config = {
    programs.nix-index = {
      enable = lib.mkDefault true;
      package = lib.mkDefault nix-index-with-db;
    };

    home = {
      packages = lib.optional config.programs.nix-index-database.comma.enable comma-with-db;

      file."${config.xdg.cacheHome}/nix-index/files" =
        lib.mkIf config.programs.nix-index.symlinkToCacheHome
          { source = databases.${pkgs.stdenv.system}.database; };
    };
  };
}
