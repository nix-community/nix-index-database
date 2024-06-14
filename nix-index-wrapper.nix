{
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  nix-index-unwrapped,
  nix-index-database,
}:
symlinkJoin {
  name = "nix-index-with-db-${nix-index-unwrapped.version}";
  paths = [ nix-index-unwrapped ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  postBuild = ''
    mkdir -p $out/share/cache/nix-index
    ln -s ${nix-index-database} $out/share/cache/nix-index/files

    wrapProgram $out/bin/nix-locate \
      --set NIX_INDEX_DATABASE $out/share/cache/nix-index

    mkdir -p $out/etc/profile.d
    rm -f "$out/etc/profile.d/command-not-found.sh"
    substitute \
     "${nix-index-unwrapped}/etc/profile.d/command-not-found.sh" \
     "$out/etc/profile.d/command-not-found.sh" \
     --replace-fail "${nix-index-unwrapped}" "$out"
  '';

  meta.mainProgram = "nix-locate";
}
