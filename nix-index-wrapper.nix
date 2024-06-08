{ lib
, symlinkJoin
, makeBinaryWrapper
, nix-index-unwrapped
, nix-index-database
,
}:
symlinkJoin {
  name = "nix-index-with-db-${nix-index-unwrapped.version}";
  paths = [ nix-index-unwrapped ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  postBuild = ''
    mkdir -p $out/share/cache/nix-index
    ln -s ${nix-index-database} $out/share/cache/nix-index/files

    ${if lib.versionAtLeast nix-index-unwrapped.version "0.1.6" then
    ''
      wrapProgram $out/bin/nix-locate \
        --set NIX_INDEX_DATABASE $out/share/cache/nix-index
    ''
    else
    ''
      wrapProgram $out/bin/nix-locate \
        --set XDG_CACHE_HOME $out/share/cache
    ''
    }
  '';

  meta.mainProgram = "nix-locate";
}
