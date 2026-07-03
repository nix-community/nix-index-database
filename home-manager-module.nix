{
  lib,
  pkgs,
  config,
  ...
}:
let
  packages = import ./. { inherit pkgs; };
in
{
  imports = [
    ./nix/shared.nix
    ./nix/home-manager-options.nix
  ];
  options.programs.nix-index-database = {
    package = lib.mkPackageOption packages "nix-index-with-db" { };
  };

  config = {
    programs.nix-index.package = lib.mkDefault config.programs.nix-index-database.package;

    home = {
      packages = lib.mkIf config.programs.nix-index-database.comma.enable [
        packages.comma-with-db
      ];

      file."${config.xdg.cacheHome}/nix-index/files" =
        lib.mkIf config.programs.nix-index.symlinkToCacheHome
          { source = packages.nix-index-database; };
    };
  };
}
