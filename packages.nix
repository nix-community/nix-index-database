# this file is autogenerated by .github/workflows/update.yml
{
  x86_64-linux.database = builtins.fetchurl {
    url = "https://github.com/Mic92/nix-index-database/releases/download/2022-12-25/index-x86_64-linux";
    sha256 = "0hkm4hvbs7nslaarj8fh8kh491j6daz0q7blpcsn8n60i3gj4xjk";
  };
  x86_64-darwin.database = builtins.fetchurl {
    url = "https://github.com/Mic92/nix-index-database/releases/download/2022-12-25/index-x86_64-darwin";
    sha256 = "11n0j293wz95rnxazw690mqvpn2vfm75wyymqd4jj8wf5dmwaav0";
  };
  aarch64-linux.database = builtins.fetchurl {
    url = "https://github.com/Mic92/nix-index-database/releases/download/2022-12-25/index-aarch64-linux";
    sha256 = "1ympy38088ydbcmc1pwwxdhflm2vamr4mskx51f7p3f6bw55wz30";
  };
}