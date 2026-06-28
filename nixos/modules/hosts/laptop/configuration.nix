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
    ];
  };

  # This is your configuration.nix, a place where you configure your system
  # You can place it in a separate file.
  flake.nixosModules.laptopModule = { pkgs, config, ... }: let
    unstable   = import inputs.unstable { system = pkgs.stdenv.hostPlatform.system; config.allowUnfree = true; };
    old-stable = inputs.old-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    customI3   = true;
    dotFilesRoot = ../../../..;
  in let global-system-packages = with pkgs; {
      code-editors = [
        unstable.neovim
        unstable.lazygit
      ];

      lsp-servers = [
        unstable.arduino-language-server
        clang-tools
        languagetool
        ltex-ls-plus
        ltex-ls
        ty
      ];

      dev-tools = [
        valgrind
        gnumake
        cmake
        serie
        act  # Build GitHub’s CI locally
        # those should go in Ergo‑L’s repo
        unstable.hugo
        unstable.pandoc
        nginx
      ];

      languages-and-compilers = [
        unstable.cargo
        scilab-bin
        python3
        clang
      ];

      rice-and-cli-tools = [
        old-stable.llpp
        onefetch
        tealdeer
        ripgrep
        feh
        fd
        nh
      ];

      gui-apps = [
        inputs.zen-browser.packages.x86_64-linux.default
        simplescreenrecorder
        libreoffice-qt
        firefox
        tor-browser
        thunderbird
        thunar
        pcmanfm
        element-desktop
        picoscope
        hunspell # Libs for libreoffice
        hunspellDicts.uk_UA
        hunspellDicts.th_TH
      ];

      chat = [
        spotify
        discord
        telegram-desktop
        signal-desktop
        zulip
        zulip-term
      ];

      art-apps = [
        kdePackages.kdenlive
        old-stable.ardour  # Stable and Unstable versions are broken.
        # unstable.musescore
        # unstable.muse-sounds-manager
        inkscape
        unstable.blender
        unstable.krita
        unstable.gimp
      ];

      keyboard-stuff = [
        unstable.kanata
        unstable.qmk
        unstable.chrysalis
      ];

      lower-level-system = [
        brightnessctl
        xmodmap
        pulseaudio
        # signaldctl
        alsa-lib
        iptables # needed by waydroid
        libiconv
        xdotool
        killall
        bottom
        btop
        xclip
        wl-clipboard-rs
        unzip
        wget
        curl
        zip
      ];

      linked-libraries = [
        libxcursor # needed by Niri for some reason ?
        libxi
      ];

      miscellaneous = [
        protontricks  # For Steam proton
        home-manager
        xfce4-screenshooter
        # love  # 2d lua game engine, for olympus (celeste mod installer)
        unstable.olympus  # Celeste mod installer
        jay  # Wayland compositor I wanna try out
      ];

    };
  in {
    # Allow unfree packages
    networking.hostName = "nixos"; # Define your hostname.
    networking.nftables.enable = true; # Needed by waydroid
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Paris";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

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
      # Auto maunt usb devices
      udisks2.enable = true;
      devmon.enable  = true;
      gvfs.enable    = true;

      pulseaudio.enable = true;
      pipewire.enable   = false;

      flatpak.enable = true;

      thermald.enable = true;

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

      nginx = {
        enable = true;
        recommendedGzipSettings  = true;
        recommendedOptimisation  = true;
        recommendedProxySettings = true;
        recommendedTlsSettings   = true;

        virtualHosts.localhost = {
          # addSSL = true;
          # enableACME = true;
          # default = true;
          root = "${config.users.users.nuclear-squid.home}/Code/www/";
          # locations."/var/html/".proxyPass = "http://localhost:8000";
        };
        # appendHttpConfig = "listen 127.0.0.1:80";
      };

      # Upload programs to Mbed arduino boards
      udev.extraRules = ''
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="2e8a", MODE:="0666"
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", MODE:="0666"
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="1fc9", MODE:="0666"
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="0525", MODE:="0666"
      '';

      # udev.packages = with pkgs; [ via ];
    };

    programs = {
      nix-ld.enable = true;
      fish.enable = true;
      # ssh.startAgent = true;

      steam = {
        enable = true;
        package = unstable.steam;
        # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      };
    };

    # Docker
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    virtualisation.waydroid.enable = true;

    environment = {
      pathsToLink = [
        "/libexec"    # Needed by i3
        "/share/zsh"  # Needed by zsh
      ];

      variables = {
        EDITOR = "nvim";
        EXA_COLORS = "di=01;35:uu=03;33:ur=33:uw=33:gw=33:gx=01;32:tw=33:tx=01;32:sn=35";
        LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath global-system-packages.linked-libraries}:$LD_LIBRARY_PATH";
      };

      systemPackages = builtins.concatLists (builtins.attrValues global-system-packages);
    };

    fonts.packages = with pkgs.nerd-fonts; [
      fantasque-sans-mono
      monaspace
    ];
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
