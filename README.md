# nix-index-database

Weekly updated [nix-index](https://github.com/bennofs/nix-index) database

This repository also provides nixos modules and home-manager modules that add a
`nix-index` wrapper to use the database from this repository.

The home-manager module also allows integration with the existing `command-not-found`
functionality.

## Usage in NixOS

Include the nixos module in your configuration

```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  inputs.nix-index-database.url = "github:Mic92/nix-index-database";

  outputs = { self, nixpkgs, nix-index-database, ... }: {
    nixosConfigurations = {
      my-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nix-index-database.nixosModules.nix-index
        ];
      };
    };
  };
}
```


## Usage in Home-manager

1. Follow the [manual](https://github.com/nix-community/home-manager/blob/master/docs/nix-flakes.adoc) to set up home-manager with flakes.
2. Include the home-manager module in your configuration:

```nix
{
  inputs = {
    nix-index-database.url = "github:Mic92/nix-index-database";

    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, nix-index-database, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.jdoe = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nix-index-database.hmModules.nix-index
        ];
      };
    };

}
```

Additionally, if your shell is managed by home-manager, you can have `nix-index`
integrate with your shell's `command-not-found` functionality by
setting `programs.nix-index.enable = true`.


## Ad-hoc download

```shell
download_nixpkgs_cache_index () {
  filename="index-$(uname -m)-$(uname | tr A-Z a-z)"
  mkdir -p ~/.cache/nix-index && cd ~/.cache/nix-index
  # -N will only download a new version if there is an update.
  wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
  ln -f $filename files
}

download_nixpkgs_cache_index
```
