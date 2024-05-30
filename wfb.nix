{ config, ... }: {
  config = {
    boot.extraModulePackages = with config.boot.kernelPackages;
      [ rtl88xxau-aircrack ];

    networking.firewall.interfaces.wfb0 = {
      allowedTCPPorts = [ 22 2222 14550 9000 9001 ];
      allowedUDPPortRanges = [{
        from = 14000;
        to = 15000;
      }];
    };

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="net", DRIVERS=="rtl88XXau", NAME="wfb0"
    '';

  };
}
