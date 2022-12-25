{ runCommand
, makeWrapper
, nix-index
, nix-index-database
}:
runCommand "nix-index"
{
  nativeBuildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/share/cache/nix-index
  ln -s ${nix-index-database} $out/share/cache/nix-index/files
  makeWrapper ${nix-index}/bin/nix-locate $out/bin/nix-locate \
    --set XDG_CACHE_HOME $out/share/cache
''
