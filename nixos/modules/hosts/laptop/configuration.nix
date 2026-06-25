{ self, inputs, ... }: {

  # This is your system configuration entry-point
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopHardware
      self.nixosModules.laptopModule
      self.nixosModules.HomeManager
    ];
  };

  # This is your configuration.nix, a place where you configure your system
  # You can place it in a separate file.
  flake.nixosModules.laptopModule = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.vim
      pkgs.firefox
    ];

    programs.fish.enable = true;

    users.users.nuclear-squid = {
      isNormalUser = true;
      shell = pkgs.fish;
    };
    home-manager.users.nuclear-squid = self.homeModules.nuclear-squid;
  };

  flake.nixosModules.laptopHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_zen;

    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
        { device = "/dev/disk/by-uuid/9a05b075-bdbd-4c5f-915a-2453b6d0b29d";
            fsType = "ext4";
        };

    fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/2DEA-E195";
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

    # hardware.intelgpu.vaapiDriver = "intel-media-driver";

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.11"; # Did you read the comment?
  };
}
