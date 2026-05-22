{
  description = "AdsPower Global - FHS Environment (Modular)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        adspower = pkgs.callPackage ./adspower.nix {};
      in {
        packages.default = adspower;
        apps.default = flake-utils.lib.mkApp {drv = adspower;};
      }
    );
}
