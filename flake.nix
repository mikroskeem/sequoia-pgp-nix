{
  description = "sequoia-pgp";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";

    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    let
      supportedSystems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-linux"
        "x86_64-darwin"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import rust-overlay)
          ];
        };

        # https://rust-lang.github.io/rustup-components-history/
        mkRustPlatform = flavor: version:
          let
            toolchain = pkgs.rust-bin.${flavor}."${version}".minimal;
          in
          pkgs.makeRustPlatform {
            cargo = toolchain;
            rustc = toolchain;
          };
      in
      rec {
        packages.sq = pkgs.callPackage ./sq.nix {
          inherit (pkgs.darwin.apple_sdk.frameworks) Security;

          rustPlatform = mkRustPlatform "stable" "1.56.1";
        };

        packages.pks-openpgp-card = pkgs.callPackage ./pks-openpgp-card.nix {
          rustPlatform = mkRustPlatform "stable" "1.56.1";
        };
      });
}
