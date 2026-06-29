{ self, inputs, ... }: {
  flake.nixosModules.low-level-jank = { pkgs, ... }: {
    # Allow unfree packages
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

    services = {
      # Auto maunt usb devices
      udisks2.enable = true;
      devmon.enable  = true;
      gvfs.enable    = true;

      pulseaudio.enable = true;
      pipewire.enable   = false;

      # flatpak.enable = true;

      thermald.enable = true;
    };

    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
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
  };
}
