{
  description = "nix-wfb nixos configurations for wfb-ng system";
  nixConfig = {
    extra-substituters =
      [ "https://raspberry-pi-nix.cachix.org" "https://wfb-pi.cachix.org" ];
    extra-trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
      "wfb-pi.cachix.org-1:T41vAtTN5vC3hG5wZzVx2+x5Fdk1gjsPAxsJ0uTZK1M="
    ];
  };
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";
    wfb-ng = {
      url = "github:Nub/wfb-ng/zbt/nix";
      # ref = "zbt/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
    let inherit (nixpkgs.lib) nixosSystem;
    in 
    utils.lib.eachDefaultSystem (system: {
        wfb = nixosSystem {
          inherit system;
          modules = [ 
              inputs.wfb-ng.nixosModules.${system}.wfb
              (import ./config.nix)
          ];
        };
    }) 
    // # Inject custom pi variant
    {
      nixosConfigurations = {
        wfb-pi = nixosSystem rec {
          system = "aarch64-linux";
          modules = [
            inputs.raspberry-pi-nix.nixosModules.raspberry-pi
            (import ./pi-hardware.nix)
            inputs.wfb-ng.nixosModules.${system}.wfb
            (import ./config.nix)
          ];
        };
      };
    };
}
