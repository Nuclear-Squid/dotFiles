{ config, pkgs, ... }:
let
    unstable   = import <nixos-unstable>   { config = config.nixpkgs.config; };
    old-stable = import <nixos-old-stable> { config = config.nixpkgs.config; };
    powersave_mode = true;
in let global-system-packages = with pkgs; {
        code-editors = [
            unstable.neovim
            unstable.neovide
            lazygit
        ];

        dev-tools = [
            valgrind
            gnumake
            cmake
            unstable.gh
            # those should go in Ergo‑L’s repo
            unstable.hugo
            unstable.pandoc
        ];

        languages-and-compilers = [
            unstable.cargo
            arduino-cli
            nodejs_22
            python3
            clang
            gcc
        ];

        rice-and-cli-tools = [
            onefetch
            tealdeer
            ripgrep
            mupdf
            feh
            fd
        ];

        gui-apps = [
            simplescreenrecorder
            libreoffice-qt
            tor-browser
            thunderbird
            xfce.thunar
            spotify
            discord
            zoom-us
            hunspell # Libs for libreoffice
            hunspellDicts.uk_UA
            hunspellDicts.th_TH
        ];

        art-apps = [
            kdePackages.kdenlive
            old-stable.ardour  # Stable and Unstable versions are brocken.
            inkscape
            blender
        ];

        keyboard-stuff = [
            unstable.kanata
            xorg.xkbcomp
            unstable.qmk
            via
        ];

        lower-level-system = [
            brightnessctl
            xorg.xmodmap
            pulseaudio
            signaldctl
            pkg-config
            alsa-lib
            libiconv
            xdotool
            killall
            xclip
            unzip
            wget
            zip
        ];

        miscellaneous = [
            home-manager
            xfce.xfce4-screenshooter
            unstable.prismlauncher  # Minecraft launcher
            love  # 2d lua game engine, for olympus (celeste mod installer)
        ];

    };
in
{
    # Allow unfree packages
    nixpkgs.config = {
        allowUnfree = true;
        pulseaudio = true;
    };

    imports = [ # Include the results of the hardware scan.
        /etc/nixos/hardware-configuration.nix
        # ./home.nix
    ];

    nix.optimise.automatic = true; # Optimise storage space of NixOS

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_zen;

    networking.hostName = "nixos"; # Define your hostname.
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
        extraGroups = [ "networkmanager" "wheel" "audio" ];
        packages = with pkgs; [];
    };

    # Configure keymap in X11
    services = {
        # Auto maunt usb devices
        udisks2.enable = true;
        devmon.enable = true;
        gvfs.enable = true;

        flatpak.enable = true;
        displayManager.defaultSession = "none+i3";

        xserver = {
            enable = true;
            xkb.layout = "fr";
            xkb.variant = "ergol";

            desktopManager.xterm.enable = false;

            windowManager.i3 = {
                enable = true;
                package = unstable.i3;
            };

            displayManager.sessionCommands = ''
                ${pkgs.xorg.xmodmap}/bin/xmodmap -e "remove mod3 = Hyper_L"
                ${pkgs.xorg.xmodmap}/bin/xmodmap -e "add mod4 = Hyper_L"
            '';
        };


        thermald.enable = powersave_mode;

        tlp = {
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

        kanata = {
            enable = true;
            package = unstable.kanata;
            keyboards.laptop = {
                devices = [ "/dev/input/event0" ];
                config = builtins.readFile ../kanata.kbd;
                extraDefCfg = ''
                    sequence-input-mode hidden-delay-type
                    process-unmapped-keys yes
                '';
            };
        };

        udev.packages = with pkgs; [ via ];
    };

    programs = {
        nix-ld.enable = true;
        zsh.enable = true;
        ssh.startAgent = true;

        steam = {
            enable = true;
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        };
    };

    environment = {
        pathsToLink = [
            "/libexec"    # Needed by i3
            "/share/zsh"  # Needed by zsh
        ];

        variables = {
            EDITOR = "nvim";
            EXA_COLORS = "di=01;35:uu=03;33:ur=33:uw=33:gw=33:gx=01;32:tw=33:tx=01;32:sn=35";
        };

        systemPackages = builtins.concatLists (builtins.attrValues global-system-packages);
    };

    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        config.common.default = "*";  # XXX: keep xdg-portal behaviour in <1.17.
                                      # May break stuff, honnestly I have no
                                      # idea what it means
    };

    fonts.packages = [ pkgs.nerdfonts ];
    fonts.fontconfig.useEmbeddedBitmaps = true;

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

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.11"; # Did you read the comment?
}
