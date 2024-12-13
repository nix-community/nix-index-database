{ config, lib, ... }: {
  options = {
    programs = {
      nix-index-database.comma.enable = lib.mkEnableOption "wrapping comma with nix-index-database and put it in the PATH";

      # TODO: Remove this option after the release of nixos-25.11.
      nix-index.acknowledgeBreakingChange = lib.mkOption {
        default = false;
        example = true;
        description = ''Whether to acknowledge the breaking change introduced in PR https://github.com/nix-community/nix-index-database/pull/132 ("treewide: disable programs.nix-index.enable option by default").'';
        type = lib.types.bool;
      };
    };
  };

  config.programs.nix-index.enable = lib.mkDefault (
    lib.warnIfNot
    config.programs.nix-index.acknowledgeBreakingChange
    "nix-index-database: programs.nix-index.enable no longer defaults to true. To disable this warning, set 'programs.nix-index.acknowledgeBreakingChange = true;' or override programs.nix-index.enable."
    false
  );
}
