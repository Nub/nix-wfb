{ pkgs, inputs, system, ... }:
{


  networking.hostName = "wfb";
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;

  # TODO: remove temp wifi networks
  networking.wireless.networks.BigHertz.psk = "somethingbig";
  networking.wireless.networks.LilHertz.psk = "somethinglil";

  # TODO: make these into module options
  networking.useDHCP = false;
  networking.interfaces.wlan0.useDHCP = true;

  users.users.wfb = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    password = "wfb";
    shell = pkgs.fish;
  };

  environment.variables = { EDITOR = "nvim"; };

  environment.shellAliases = {
    jfu = "journalctl --output cat -fu";
    ctl = "sudo systemctl";
    wfb_drone = "cd ~/wfb; wfb-server udp_drone wfb0";
    wfb_gs = "cd ~/wfb; wfb-server udp_gs wfb0";
    rbs = "sudo nixos-rebuild switch --flake";
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

  services.wfb.enable = true;
  services.openssh.enable = true;
  services.openssh.ports = [ 22 2222 ];
  services.tailscale.enable = true;

  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ stdenv.cc.cc openssl libudev0-shim ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" "repl-flake" ];
  nix.settings.trusted-users = [ "merops" "@wheel" ];
  nix.settings = {
    substituters =
      [ "https://raspberry-pi-nix.cachix.org" "https://wfb-pi.cachix.org" ];
    trusted-public-keys = [
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
      "wfb-pi.cachix.org-1:T41vAtTN5vC3hG5wZzVx2+x5Fdk1gjsPAxsJ0uTZK1M="
    ];
  };

  system.stateVersion = "23.11";
}
