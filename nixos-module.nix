{ packages }:
{ pkgs, ... }: {
  environment.systemPackages = [
    packages.${pkgs.system}.nix-index-with-db
  ];
}
