# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, callPackage, ... }:
{
    # Allow unfree packages
    nixpkgs.config = {
        allowUnfree = true;
        pulseaudio = true;
    };

    imports = [ # Include the results of the hardware scan.
        /etc/nixos/hardware-configuration.nix
        ./home-manager.nix
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

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

    # Configure keymap in X11
    services = {
        xserver = {
            enable = true;
            layout = "us";
            xkbVariant = "";

            desktopManager = {
                xterm.enable = false;
            };

            displayManager = {
                defaultSession = "none+i3";
            };

            windowManager.i3 = {
                enable = true;
                extraPackages = with pkgs; [
                    i3status
                    i3lock
                ];
            };
        };

        picom = {
            enable = true;
            settings.animations = true;
            # package = pkgs.picom-allusive;
            # package = pkgs.picom-jonaburg.overrideAttrs (oldAttrs: {
            #     inherit oldAttrs;
            #     meta.mainProgram = "picom";
            # });
            # package = pkgs.picom-jonaburg // {
            #     meta.mainProgram = "picom";
            # };
            # settings.experimentalBackend = true;
            settings.corner-radius = 10;
            settings.roundBorder = 1;
            # settings.inactive-opacity = 0;
        };

        kanata = {
            enable = true;
            keyboards.laptop = {
                devices = [ "/dev/input/event0" ];
                config = builtins.readFile ../kanata.kbd;
            };
        };
    };

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.nuclearsquid = {
        isNormalUser = true;
        description = "Nuclear Squid";
        extraGroups = [ "networkmanager" "wheel" "audio" ];
        packages = with pkgs; [];
    };


    programs.nix-ld.enable = true;

    environment = {
        pathsToLink = [
            "/libexec"    # Needed by i3
            "/share/zsh"  # Needed by zsh
        ];

        variables = {
            EDITOR = "nvim";
            EXA_COLORS = "di=01;35:uu=03;33:ur=33:uw=33:gw=33:gx=01;32:tw=33:tx=01;32:sn=35";
        };

        systemPackages = with pkgs; [
            neovim
            wget
            gnumake
            firefox
            pulseaudio
            xorg.xkbcomp
            xclip
            xdotool
            killall
            discord
            home-manager
            rustc
            cargo
            xfce.xfce4-screenshooter
            thunderbird
            fd
            neofetch
            onefetch
            feh
            kanata
            ranger
            ripgrep
            unzip
            gcc
            go
            nodejs_21
      ];
    };

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
    system.stateVersion = "23.11"; # Did you read the comment?
}
