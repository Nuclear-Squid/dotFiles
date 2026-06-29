{ self, inputs, ... }: {

  # This is your system configuration entry-point
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopHardware
      self.nixosModules.laptopModule
      self.nixosModules.HomeManager
      self.nixosModules.niri
      self.nixosModules.i3
      self.nixosModules.nix-config
      self.nixosModules.low-level-jank
      self.nixosModules.desktop-apps
      self.nixosModules.dev-environment
    ];
  };

  # This is your configuration.nix, a place where you configure your system
  # You can place it in a separate file.
  flake.nixosModules.laptopModule = { pkgs, config, lib, ... }: let
    unstable   = import inputs.unstable { system = pkgs.stdenv.hostPlatform.system; config.allowUnfree = true; };
    dotFilesRoot = ../../..;
  in let global-system-packages = with pkgs; {
      rice-and-cli-tools = [
        llpp
        onefetch
        tealdeer
        ripgrep
        feh
        fd
        nh
      ];

      keyboard-stuff = [
        unstable.kanata
        unstable.qmk
        unstable.chrysalis
      ];

      linked-libraries = [
        # libxi
      ];

      miscellaneous = [
        home-manager
      ];

    };
  in {
    users.defaultUserShell = pkgs.fish;
    users.users.nuclear-squid = {
      isNormalUser = true;
      description = "Nuclear Squid";
      extraGroups = [
        "networkmanager"
        "wheel"  # Enable 'sudo' for the user.
        "audio"
        "dialout"  # Allow access to serial device (for Arduino dev)
        "docker"  # Allow using docker without root access
        "nginx"  # Allow using nginx in localhost
      ];
      packages = with pkgs; [];
    };

    home-manager.users.nuclear-squid = self.homeModules.nuclear-squid;

    specialisation = {
      powersave.configuration = {
        services.tlp = {
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
      };
    };

    services = {
      kanata = {
        enable = true;
        package = unstable.kanata;
        keyboards.laptop = {
          devices = [ "/dev/input/event0" ];
          config = builtins.readFile (dotFilesRoot + /kanata.kbd);
          extraDefCfg = ''
            sequence-input-mode hidden-delay-type
            process-unmapped-keys yes
            concurrent-tap-hold yes
            chords-v2-min-idle 120
          '';
        };
      };

      # udev.packages = with pkgs; [ via ];
    };

    environment = {
      variables = {
        # LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath global-system-packages.linked-libraries}:$LD_LIBRARY_PATH";
        # LD_LIBRARY_PATH = [ lib.getLib pkgs.libxi ];
      };

      systemPackages = builtins.concatLists (builtins.attrValues global-system-packages);
    };

    # fonts.packages = [ pkgs.nerdfonts ];
    # fonts.fontconfig.useEmbeddedBitmaps = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
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
