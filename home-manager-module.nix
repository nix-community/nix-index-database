{ lib, ... }:
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
  config.programs.nix-index.enable = lib.mkDefault true;
}
