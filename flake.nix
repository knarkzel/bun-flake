{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
    version = "0.4.0";
    sha256 = "sha256-LMutdGNiGp4aLmeqMLk8Pc0xIjqgWPO6GSli1EfTgkY=";
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
