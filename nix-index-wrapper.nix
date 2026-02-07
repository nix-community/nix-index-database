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
    rm -f "$out/etc/profile.d/command-not-found.sh"
    rm -f "$out/etc/profile.d/command-not-found.nu"
    substitute \
     "${nix-index-unwrapped}/etc/profile.d/command-not-found.sh" \
     "$out/etc/profile.d/command-not-found.sh" \
     --replace-fail "${nix-index-unwrapped}" "$out"

    substitute \
     "${nix-index-unwrapped}/etc/profile.d/command-not-found.nu" \
     "$out/etc/profile.d/command-not-found.nu" \
     --replace-fail "${nix-index-unwrapped}" "$out"
  '';

  meta.mainProgram = "nix-locate";
}
