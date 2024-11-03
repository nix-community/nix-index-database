self:
{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./nix/home-manager-options.nix
  ];
  programs.nix-index.package = lib.mkDefault self.packages.${pkgs.stdenv.system}.nix-index-with-db;

  home = {
    packages = lib.mkIf config.programs.nix-index-database.comma.enable [
      self.packages.${pkgs.stdenv.system}.comma-with-db
    ];

    file."${config.xdg.cacheHome}/nix-index/files" =
      lib.mkIf config.programs.nix-index.symlinkToCacheHome
        { source = self.packages.${pkgs.stdenv.system}.nix-index-database; };
  };
  _file = ./home-manager-module.nix;
}
