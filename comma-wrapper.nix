{
  linkFarm,
  makeBinaryWrapper,
  comma,
  nix-index-unwrapped,
  nix-index-database,
}:

(comma.override {
  inherit nix-index-unwrapped;
}).overrideAttrs
  (oldAttrs: {
    pname = "comma-with-db";

    nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ makeBinaryWrapper ];

    databaseDirectory = linkFarm "nix-index-database" { files = nix-index-database; };

    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        for cmd in "," "comma"; do
          wrapProgram "$out/bin/$cmd" --set NIX_INDEX_DATABASE $databaseDirectory
        done
      '';
  })
