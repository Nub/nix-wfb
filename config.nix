{ pkgs, ... }:
let 
  nixos_cfg = ./.;
in{
  imports = map (x: import x) [ ./wfb.nix ./hardware.nix ];

  networking.hostName = "wfb-pi";
  networking.wireless.enable = true;
  # networking.userControlled.enable = true;
  networking.wireless.networks.BigHertz.psk = "somethingbig";
  networking.wireless.networks.LilHertz.psk = "somethinglil";

  # networking.useDHCP = false;
  # networking.interfaces.enp0s1.useDHCP = true;
  # networking.interfaces.enp0s2.useDHCP = true;

  users.users.merops = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIngpCTE3a8QDHarFnqa9O08MbmOlPNzptmfQ233yGzn zachthayer@F915Q2RDFY"
    ];
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "merops";
    shell = pkgs.fish;
  };

  environment.variables = {
    NIX_CFG = nixos_cfg;
  };

  environment.shellAliases = {
    jfu = "journalctl --output cat -fu";
    ctl = "sudo systemctl";
    wfb_drone = "cd ~/wfb; wfb-server udp_drone wfb0";
    wfb_gs = "cd ~/wfb; wfb-server udp_gs wfb0";
    install_nixos_cfg = "cp -r '$NIX_CFG' ~/nixos_cfg";
  };

  environment.systemPackages = with pkgs; [
    nixfmt
    iperf
    iw
    networkmanager
    git
    neovim
    lunarvim
    tailscale
    nixfmt
    fzf
    ripgrep
    zellij
    usbutils
    fishPlugins.bass
  ];

  services.openssh.enable = true;
  services.openssh.ports = [ 22 2222 ];
  services.tailscale.enable = true;

  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ stdenv.cc.cc openssl libudev0-shim ];

  nix.settings.experimental-features = [ "nix-command" "flakes" "repl-flake" ];
  nix.settings.trusted-users = ["merops" "root"];
  nix.settings = {
    extra-substituters = [ "https://raspberry-pi-nix.cachix.org" ];
    extra-trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
    ];
  };
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
