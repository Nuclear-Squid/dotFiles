{ self, inputs, ... }: {
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    modules = (builtins.attrValues self.nixosModules) ++ [
      ({ config, lib, pkgs, modulesPath, ... }: {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.kernelPackages = pkgs.linuxPackages_zen;

        boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/9a05b075-bdbd-4c5f-915a-2453b6d0b29d";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/2DEA-E195";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };

        swapDevices = [ ];

        # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
        # (the default) this is the recommended approach. When using systemd-networkd it's
        # still possible to use this option, but it's recommended to use it in conjunction
        # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
        networking.useDHCP = lib.mkDefault true;
        # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
        # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        # hardware.pulseaudio.enable = true;

        hardware.keyboard.qmk.enable = true;

        hardware.graphics = {
          enable = true;
          #   extraPackages = with pkgs; [ intel-media-sdk intel-media-driver intel-ocl intel-vaapi-driver ];
          extraPackages = with pkgs; [ vpl-gpu-rt ];
        };

        # environment.variables.LD_LIBRARY_PATH = [ lib.getLib pkgs.libxi ];
        specialisation.powersave.configuration.services.tlp = {
          enable = true;
          settings = {
            CPU_SCALING_GOVERNOR_ON_AC  = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            PLATFORM_PROFILE_ON_BAT     = "low-power";

            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            CPU_ENERGY_PERF_POLICY_ON_AC  = "performance";
            PLATFORM_PROFILE_ON_AC        = "performance";

            CPU_MIN_PERF_ON_AC  = 0;
            CPU_MAX_PERF_ON_AC  = 100;
            CPU_MIN_PERF_ON_BAT = 0;
            CPU_MAX_PERF_ON_BAT = 20;

            # Helps save long term battery health
            START_CHARGE_THRESH_BAT0 = 40;  # 40 and bellow it starts to charge
            STOP_CHARGE_THRESH_BAT0 = 80;   # 80 and above it stops charging
          };
        };

        # hardware.intelgpu.vaapiDriver = "intel-media-driver";

        # This value determines the NixOS release from which the default
        # settings for stateful data, like file locations and database versions
        # on your system were taken. It‘s perfectly fine and recommended to leave
        # this value at the release version of the first install of this system.
        # Before changing this value read the documentation for this option
        # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
        system.stateVersion = "24.11"; # Did you read the comment?
      })
    ];
  };
}
