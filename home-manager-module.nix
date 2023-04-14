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
  };
  config = {
    programs.nix-index = {
      enable = lib.mkDefault true;
      package = packages.${pkgs.stdenv.system}.nix-index-with-db;
    };

    home.file."${config.xdg.cacheHome}/nix-index/files" =
      lib.mkIf config.programs.nix-index.symlinkToCacheHome
        { source = legacyPackages.${pkgs.stdenv.system}.database; };
  };
}
