{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        crossSystem = {
          config = "x86_64-unknown-linux-musl";
          rustc.config = "x86_64-unknown-linux-musl";
          isStatic = true;
        };
      };
    in {
      packages.default = with pkgs;
        rustPlatform.buildRustPackage rec {
          pname = "hermes";
          version = "1.0.0";
          src = fetchTarball {
            url = "https://github.com/mmsqe/ibc-rs/archive/refs/heads/add_refresh.tar.gz";
            sha256 = "sha256:0g0z3sli64cybr2fgqckvbbkccmrhiyr9ri1zksizmk73jcm3kbf";
          };
          nativeBuildInputs = [pkg-config];
          buildInputs = [openssl];
          doCheck = false;
          cargoLock = {
            lockFile = "${src}/Cargo.lock";
            allowBuiltinFetchGit = true;
          };
        };
    });
}
