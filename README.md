# bun-flake

```
$ nix flake show github:knarkzel/bun-flake
└───packages
    └───x86_64-linux
        └───default: package 'bun-0.2.2'
$ nix build github:knarkzel/bun-flake
$ ./result/bin/bun
bun: a fast bundler, transpiler, JavaScript Runtime and package manager for web software.

  dev       ./a.ts ./b.jsx        Start a bun Dev Server
  bun       ./a.ts ./b.jsx        Bundle dependencies of input files into a .bun

  init                            Start an empty Bun project from a blank template
  create    next ./app            Create a new project from a template (bun c)
  run       test                  Run JavaScript with bun, a package.json script, or a bin
  install                         Install dependencies for a package.json (bun i)
  add       react                 Add a dependency to package.json (bun a)
  link                            Link an npm package globally
  remove    @parcel/core          Remove a dependency from package.json (bun rm)
  unlink                          Globally unlink an npm package

  upgrade                         Get the latest version of bun
  completions                     Install shell completions for tab-completion
  discord                         Open bun's Discord server
  help                            Print this help menu
```

## Minimal example

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    bun-flake = {
      url = "github:knarkzel/bun-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    bun-flake,
  }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
    bun = bun-flake.packages.x86_64-linux.default;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [bun];
    };
  };
}
```
