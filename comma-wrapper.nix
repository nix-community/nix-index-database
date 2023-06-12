{ runCommand
, makeWrapper
, comma
, nix-index-unwrapped
, nix-index-database
}:
let
  commaOverridden = comma.override { inherit nix-index-unwrapped; };
in
runCommand "comma-with-db-${comma.version}"
{
  nativeBuildInputs = [ makeWrapper ];
  meta.mainProgram = "comma";
} ''
  # Function that does the same as nixpkgs.lib.versionAtLeast,
  # return true if the first string denotes a version equal to or newer than
  # the second one.
  function versionAtLeast() {
    printf '%s\n' "$2" "$1" | sort --version-sort --check=quiet
  }

  mkdir -p $out/share/cache/nix-index
  ln -s ${nix-index-database} $out/share/cache/nix-index/files

  version="$(${nix-index-unwrapped}/bin/nix-index --version | cut -d' ' -f2)"

  for cmd in "," "comma"; do
    if versionAtLeast "''${version}" "0.1.6"; then
      makeWrapper ${commaOverridden}/bin/''${cmd} $out/bin/''${cmd} \
        --set NIX_INDEX_DATABASE $out/share/cache/nix-index
    else
      makeWrapper ${commaOverridden}/bin/''${cmd} $out/bin/''${cmd} \
        --set XDG_CACHE_HOME $out/share/cache
    fi
  done
''
