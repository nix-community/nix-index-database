{ lib, ... }: {
  options.programs.nix-index-database.comma.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to wrap comma with nix-index-database and put it in the PATH.";
  };

  config.programs.nix-index.enable = lib.mkDefault true;
}
