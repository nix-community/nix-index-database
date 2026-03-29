{
  linkFarm,
  symlinkJoin,
  makeBinaryWrapper,
  nix-index-unwrapped,
  nix-index-database,
  db-type ? "full",
}:
symlinkJoin {
  name = "nix-index-with-${db-type}-db-${nix-index-unwrapped.version}";
  paths = [ nix-index-unwrapped ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  databaseDirectory = linkFarm "nix-index-database" { files = nix-index-database; };
  postBuild = ''
    wrapProgram $out/bin/nix-locate \
      --set NIX_INDEX_DATABASE $databaseDirectory

    mkdir -p $out/etc/profile.d
    cd $out
    for script in etc/profile.d/command-not-found.*; do
      rm -f "$out/$script"
      substitute \
       "${nix-index-unwrapped}/$script" \
       "$out/$script" \
       --replace-fail "${nix-index-unwrapped}" "$out"
    done
  '';

  meta.mainProgram = "nix-locate";
}
