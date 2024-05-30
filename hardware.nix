{...}: {
  config = {
    # boot.loader.raspberryPi = {
    #  enable = true;
    #  version = 3;
    # };
    hardware = {
      raspberry-pi.config = {
        cm4 = {
          options = {
            otg_mode = {
              enable = true;
              value = true;
            };
          };
        };
        # pi4 = {
        #   options = {
        #     arm_boost = {
        #       enable = true;
        #       value = true;
        #     };
        #   };
        #   dt-overlays = {
        #     vc4-kms-v3d = {
        #       enable = true;
        #       params = { cma-512 = { enable = true; }; };
        #     };
        #   };
        # };
        all = {
          options = {
            # The firmware will start our u-boot binary rather than a
            # linux kernel.
            kernel = {
              enable = true;
              value = "u-boot-rpi-arm64.bin";
            };
            arm_64bit = {
              enable = true;
              value = true;
            };
            enable_uart = {
              enable = true;
              value = true;
            };
            avoid_warnings = {
              enable = true;
              value = true;
            };
            camera_auto_detect = {
              enable = true;
              value = true;
            };
            display_auto_detect = {
              enable = true;
              value = true;
            };
            disable_overscan = {
              enable = true;
              value = true;
            };
          };
          dt-overlays = {
            vc4-kms-v3d = {
              enable = true;
              params = { };
            };
          };
          base-dt-params = {
            krnbt = {
              enable = true;
              value = "on";
            };
            spi = {
              enable = true;
              value = "on";
            };
          };
        };
      };
    };
  };
}
