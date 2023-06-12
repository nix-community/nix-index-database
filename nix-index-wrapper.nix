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
  # Function that does the same as nixpkgs.lib.versionAtLeast,
  # return true if the first string denotes a version equal to or newer than
  # the second one.
  function versionAtLeast() {
    printf '%s\n' "$2" "$1" | sort --version-sort --check=quiet
  }

  mkdir -p $out/share/cache/nix-index
  ln -s ${nix-index-database} $out/share/cache/nix-index/files

  version="$(${nix-index-unwrapped}/bin/nix-index --version | cut -d' ' -f2)"

  if versionAtLeast "''${version}" "0.1.6"; then
    makeWrapper ${nix-index-unwrapped}/bin/nix-locate $out/bin/nix-locate \
      --set NIX_INDEX_DATABASE $out/share/cache/nix-index
  else
    makeWrapper ${nix-index-unwrapped}/bin/nix-locate $out/bin/nix-locate \
      --set XDG_CACHE_HOME $out/share/cache
  fi

  mkdir --parents $out/etc/profile.d
  substitute \
    "${nix-index-unwrapped}/etc/profile.d/command-not-found.sh" \
    "$out/etc/profile.d/command-not-found.sh" \
    --replace "${nix-index-unwrapped}" "$out"
''
