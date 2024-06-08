{ lib
, symlinkJoin
, makeBinaryWrapper
, comma
, nix-index-unwrapped
, nix-index-database
,
}:
let
  commaOverridden = comma.override { inherit nix-index-unwrapped; };
in
symlinkJoin {
  name = "comma-with-db-${comma.version}";
  paths = [ commaOverridden ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  postBuild = ''
    mkdir -p $out/share/cache/nix-index
    ln -s ${nix-index-database} $out/share/cache/nix-index/files

    for cmd in "," "comma"; do
      ${if lib.versionAtLeast nix-index-unwrapped.version "0.1.6" then
      ''
        wrapProgram "$out/bin/$cmd" \
          --set NIX_INDEX_DATABASE $out/share/cache/nix-index
      ''
      else
      ''
        wrapProgram "$out/bin/$cmd" \
          --set XDG_CACHE_HOME $out/share/cache
      ''
      }
    done
  '';

  meta.mainProgram = "comma";
}
