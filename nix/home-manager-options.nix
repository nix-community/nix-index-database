{ lib, config, ... }:
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
  };
}
