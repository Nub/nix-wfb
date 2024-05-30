{
  description = "nix-wfb nixos configurations for wfb-ng system";
  nixConfig = {
    extra-substituters = [ 
      "https://raspberry-pi-nix.cachix.org"
      "https://wfb-pi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
      "wfb-pi.cachix.org-1:T41vAtTN5vC3hG5wZzVx2+x5Fdk1gjsPAxsJ0uTZK1M="
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
