# nix-index-database
Weekly updated [nix-index](https://github.com/bennofs/nix-index) database

A simple integration example:
```
(
  filename="index-x86_64-$(uname | tr A-Z a-z)"
  mkdir -p ~/.cache/nix-index
  cd ~/.cache/nix-index
  # -N prevents needless refetch, does not seem to work with -O
  wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/$filename
  ln -f $filename files
)
```
