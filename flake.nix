{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
    version = "0.2.2";
    sha256 = "eVEopSvyjzY8J3q52wowTlSVHZ4s1lIc8/yU6Ya+0QU=";
    bun_install = "${builtins.getEnv "HOME"}/.bun";
  in {
    packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
      pname = "bun";
      version = version;
      src = pkgs.fetchurl {
        url = "https://github.com/Jarred-Sumner/bun-releases-for-updater/releases/download/bun-v${version}/bun-linux-x64.zip";
        sha256 = sha256;
      };
      sourceRoot = ".";
      unpackCmd = "unzip bun-linux-x64.zip";
      dontConfigure = true;
      dontBuild = true;
      nativeBuildInputs = [
        pkgs.makeWrapper
        pkgs.autoPatchelfHook
      ];
      buildInputs = [
        pkgs.unzip
        pkgs.openssl
        pkgs.stdenv.cc.cc.lib
      ];

      installPhase = "install -D ./bun-linux-x64/bun $out/bin/bun";
      postInstall = ''
        wrapProgram "$out/bin/bun" \
          --prefix BUN_INSTALL : ${bun_install}
      '';
    };
  };
}
