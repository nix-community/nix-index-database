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

  nix-index-stable-database =
    (pkgs.fetchurl {
      url = generated.url + pkgs.stdenv.system + "-stable";
      hash = generated.hashes."${pkgs.stdenv.system}-stable";
    }).overrideAttrs
      {
        __structuredAttrs = true;
        unsafeDiscardReferences.out = true;
      };

  nix-index-stable-small-database =
    (pkgs.fetchurl {
      url = generated.url + pkgs.stdenv.system + "-stable-small";
      hash = generated.hashes."${pkgs.stdenv.system}-stable-small";
    }).overrideAttrs
      {
        __structuredAttrs = true;
        unsafeDiscardReferences.out = true;
      };
in
{
  inherit
    nix-index-database
    nix-index-small-database
    nix-index-stable-database
    nix-index-stable-small-database
    ;

  nix-index-with-db = pkgs.callPackage ./nix-index-wrapper.nix { inherit nix-index-database; };
  nix-index-with-small-db = pkgs.callPackage ./nix-index-wrapper.nix {
    nix-index-database = nix-index-small-database;
    db-type = "small";
  };
  nix-index-with-stable-db = pkgs.callPackage ./nix-index-wrapper.nix {
    nix-index-database = nix-index-stable-database;
  };
  nix-index-with-stable-small-db = pkgs.callPackage ./nix-index-wrapper.nix {
    nix-index-database = nix-index-stable-small-database;
    db-type = "small";
  };
  comma-with-db = pkgs.callPackage ./comma-wrapper.nix {
    nix-index-database = nix-index-small-database;
  };
}
