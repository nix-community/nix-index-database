{ lib, ... }: {
  options = {
    programs.nix-index-database.comma.enable = lib.mkEnableOption "wrapping comma with nix-index-database and put it in the PATH";
  };

  config.programs.nix-index.enable = lib.mkDefault true;
}
