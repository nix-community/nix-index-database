{ runCommand
, makeWrapper
, nix-index-unwrapped
, nix-index-database
}:
runCommand "nix-index-with-db-${nix-index-unwrapped.version}"
{
  nativeBuildInputs = [ makeWrapper ];
  meta.mainProgram = "nix-locate";
} ''
  mkdir -p $out/share/cache/nix-index
  ln -s ${nix-index-database} $out/share/cache/nix-index/files
  makeWrapper ${nix-index-unwrapped}/bin/nix-locate $out/bin/nix-locate \
    --set XDG_CACHE_HOME $out/share/cache

  mkdir --parents $out/etc/profile.d
  substitute \
    "${nix-index-unwrapped}/etc/profile.d/command-not-found.sh" \
    "$out/etc/profile.d/command-not-found.sh" \
    --replace "${nix-index-unwrapped}" "$out"
''
