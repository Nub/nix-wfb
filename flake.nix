{
  description = "raspberry-pi-nix example";
  nixConfig = {
    extra-substituters = [ "https://raspberry-pi-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";
  };

  outputs = { self, nixpkgs, raspberry-pi-nix }:
    let
      inherit (nixpkgs.lib) nixosSystem;
    in {
      nixosConfigurations = {
        wfb-pi = nixosSystem {
          system = "aarch64-linux";
          modules = [ 
            raspberry-pi-nix.nixosModules.raspberry-pi
            (import ./config.nix)
          ];
        };
      };
    };
}
