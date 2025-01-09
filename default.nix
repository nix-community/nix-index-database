{ pkgs }:
let
  generated = import ./generated.nix;

  nix-index-database =
    (pkgs.fetchurl {
      url = generated.url + pkgs.stdenv.system;
      hash = generated.hashes.${pkgs.stdenv.system};
    }).overrideAttrs
      {
        __structuredAttrs = true;
        unsafeDiscardReferences.out = true;
      };

  nix-index-small-database =
    (pkgs.fetchurl {
      url = generated.url + pkgs.stdenv.system + "-small";
      hash = generated.hashes."${pkgs.stdenv.system}-small";
    }).overrideAttrs
      {
        __structuredAttrs = true;
        unsafeDiscardReferences.out = true;
      };
in
{
  inherit nix-index-database nix-index-small-database;

  nix-index-with-db = pkgs.callPackage ./nix-index-wrapper.nix { inherit nix-index-database; };
  nix-index-with-small-db = pkgs.callPackage ./nix-index-wrapper.nix {
    nix-index-database = nix-index-small-database;
    db-type = "small";
  };
  comma-with-db = pkgs.callPackage ./comma-wrapper.nix {
    nix-index-database = nix-index-small-database;
  };
}
