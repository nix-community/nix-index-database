# nix-index-database
Weekly updated [nix-index](https://github.com/bennofs/nix-index) database

A simple integration example:
```
(
  filename="index-x86_64-$(uname | tr A-Z a-z)"
  mkdir -p ~/.cache/nix-index
  cd ~/.cache/nix-index
  # -N will only download a new version if there is an update.
  wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
  ln -f $filename files
)
```
