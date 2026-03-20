{ inputs, ... }: {
    flake.nixosModules.nix-and-misc = { pkgs, ... }: {
        # Allow unfree packages
        nixpkgs.config = {
            allowUnfree = true;
            pulseaudio = true;
        };

        nix.optimise.automatic = true; # Optimise storage space of NixOS
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nix.settings.warn-dirty = false; # Please stop yelling at me everytime I run `nix develop`

        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.kernelPackages = pkgs.linuxPackages_zen;

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
            # packages = with pkgs; [];
        };

        programs.nix-ld.enable = true;

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


        # This value determines the NixOS release from which the default
        # settings for stateful data, like file locations and database versions
        # on your system were taken. It‘s perfectly fine and recommended to leave
        # this value at the release version of the first install of this system.
        # Before changing this value read the documentation for this option
        # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
        system.stateVersion = "24.11"; # Did you read the comment?
    };
}
