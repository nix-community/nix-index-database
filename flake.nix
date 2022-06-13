{
  description = "nix-index database";
  outputs = { nixpkgs, ... }: {
    packages.x86_64-linux.database = nixpkgs.legacyPackages.x86_64-linux.fetchurl {
      url = "https://github.com/Mic92/nix-index-database/releases/download/2022-06-12/index-x86_64-linux";
      sha256 = "09l4h2pz2lq5axgdj31kpymnvsrgfwsccdfqm4ycmg7jl1kc4qn6";
    };
    packages.x86_64-darwin.database = nixpkgs.legacyPackages.x86_64-darwin.fetchurl {
      url = "https://github.com/Mic92/nix-index-database/releases/download/2022-06-12/index-x86_64-darwin";
      sha256 = "0r7kjpcgg679r6m0s0g1imsd0xi1p6x7f42hv5l2kwl679rsrziv";
    };
  };
}
