self:
{
  lib,
  pkgs,
  config,
  ...
}:
let
  packages = pkgs.callPackage self { };
in
{
  imports = [
    ./nix/shared.nix
    ./nix/home-manager-options.nix
  ];
  programs.nix-index.package = lib.mkDefault packages.nix-index-with-db;

  home = {
    packages = lib.mkIf config.programs.nix-index-database.comma.enable [
      packages.comma-with-db
    ];

    file."${config.xdg.cacheHome}/nix-index/files" =
      lib.mkIf config.programs.nix-index.symlinkToCacheHome
        { source = packages.nix-index-database; };
  };
  _file = ./home-manager-module.nix;
}
