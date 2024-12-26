{
  linkFarm,
  symlinkJoin,
  makeBinaryWrapper,
  comma,
  nix-index-unwrapped,
  nix-index-database,
}:
let
  commaOverridden = comma.override { inherit nix-index-unwrapped; };
in
symlinkJoin {
  name = "comma-with-db-${comma.version}";
  paths = [ commaOverridden ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  databaseDirectory = linkFarm "nix-index-database" { files = nix-index-database; };
  postBuild = ''
    for cmd in "," "comma"; do
      wrapProgram "$out/bin/$cmd" \
        --set NIX_INDEX_DATABASE $databaseDirectory
    done
  '';

  meta.mainProgram = "comma";
}
