# nix-index-database

Weekly updated [nix-index](https://github.com/nix-community/nix-index) database for nixos-unstable channel.

This repository also provides nixos modules and home-manager modules that add a
`nix-index` wrapper to use the database from this repository.

The home-manager module also allows integration with the existing `command-not-found`
functionality.

## Demo

``` shell
$ nix run github:nix-community/nix-index-database bin/cntr
cntr.out                                        978,736 x /nix/store/09p2hys5bxcnzcaad3bknlnwsgdkznl1-cntr-1.5.1/bin/cntr
```

## Requirements

- Nix 2.18 or newer: In our packages we make use of `unsafeDiscardReferences` to skip the nix store checks. On older nix version these packages might fail.

## Usage in NixOS

Include the nixos module in your configuration:

> [!IMPORTANT]
> When using this module do not also include `nix-index` in your environment.systemPackages list as this
> will conflict with the nix-index wrapper provided by this project.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-index-database, ... }: {
    nixosConfigurations = {
      my-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nix-index-database.nixosModules.default
          # optional to also wrap and install comma
          # { programs.nix-index-database.comma.enable = true; }
        ];
      };
    };
  };
}
```

You can then call `nix-locate` as usual, it will automatically use the database provided by this repository.

## Usage in nix-darwin

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-index-database, ... }: {
    darwinConfigurations = {
      my-machine = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          nix-index-database.darwinModules.nix-index
          # optional to also wrap and install comma
          # { programs.nix-index-database.comma.enable = true; }
        ];
      };
    };
  };
}
```

## Usage in Home-manager

1. Follow the [manual](https://nix-community.github.io/home-manager/index.xhtml#ch-nix-flakes) to set up home-manager with flakes.
2. Include the home-manager module in your configuration:

> [!IMPORTANT]
> When using this module do not also include `nix-index` in your home.packages list as this
> will conflict with the nix-index wrapper provided by this project.

```nix
{
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, home-manager, nix-index-database, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.jdoe = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nix-index-database.homeModules.default
          # optional to also wrap and install comma
          # { programs.nix-index-database.comma.enable = true; }
        ];
      };
    };

}
```

You can then call `nix-locate` as usual, it will automatically use the database provided by this repository.

Additionally, if your shell is managed by home-manager, you can have `nix-index`
integrate with your shell's `command-not-found` functionality by
setting `programs.nix-index.enable = true`.


## Ad-hoc download

```shell
download_nixpkgs_cache_index () {
  filename="index-$(uname -m | sed 's/^arm64$/aarch64/')-$(uname | tr A-Z a-z)"
  mkdir -p ~/.cache/nix-index && cd ~/.cache/nix-index
  wget -q -N https://github.com/nix-community/nix-index-database/releases/latest/download/$filename
  ln -f $filename files
}

download_nixpkgs_cache_index
```
