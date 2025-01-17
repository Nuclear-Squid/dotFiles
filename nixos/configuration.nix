{ config, pkgs, ... }:
let
    unstable   = import <nixos-unstable>   { config = config.nixpkgs.config; };
    old-stable = import <nixos-old-stable> { config = config.nixpkgs.config; };
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
            fastfetch
            onefetch
            tealdeer
            ripgrep
            ranger
            mupdf
            feh
            fd
        ];

        gui-apps = [
            telegram-desktop
            tor-browser
            thunderbird
            xfce.thunar
            spotify
            discord
            zoom-us
            libreoffice-qt
            hunspell # Libs for libreoffice
            hunspellDicts.uk_UA
            hunspellDicts.th_TH
        ];

        art-apps = [
            kdePackages.kdenlive
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
            appimage-run
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

        wayland-specific-stuff = [
            wl-clipboard  # copy/paste to&from stdin/stdout
            slurp  # Screenshot system
            mako  # Notification system
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

    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        config.common.default = "*";  # XXX: keep xdg-portal behaviour in <1.17.
                                      # May break stuff, honnestly I have no
                                      # idea what it means
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
                extraPackages = with pkgs; [
                    i3status
                    i3lock
                ];
            };

            displayManager.sessionCommands = ''
                ${pkgs.xorg.xmodmap}/bin/xmodmap -e "remove mod3 = Hyper_L"
                ${pkgs.xorg.xmodmap}/bin/xmodmap -e "add mod4 = Hyper_L"
            '';
        };

        gnome.gnome-keyring.enable = true;  # For Sway

        picom = {
            enable = true;
            settings = {
                corner-radius = 10;
                roundBorder = 1;
                fading = true;
                fade-delta = 3;
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


    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
    };

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.nuclear-squid = {
        isNormalUser = true;
        description = "Nuclear Squid";
        extraGroups = [ "networkmanager" "wheel" "audio" ];
        packages = with pkgs; [];
    };

    programs.nix-ld.enable = true;

    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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
