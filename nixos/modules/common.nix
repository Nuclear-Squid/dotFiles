{ self, inputs, home-manager, ... }: {
    flake.nixosModules.common = { pkgs, config, wrappers, home-manager, ... }:
    let unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        self-pkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in {
        home-manager.users.nuclear-squid = ../home.nix;
        environment.systemPackages = [ pkgs.home-manager ];

        services = {
            # Auto-mount usb drives
            udisks2.enable = true;
            devmon.enable  = true;
            gvfs.enable    = true;

            pulseaudio.enable = true;
            pipewire.enable   = false;

            flatpak.enable = true;

            thermald.enable = true;
        };
    };

    flake.homeModules.common = { pkgs, ... }:
    let homeDir = "/home/nuclear-squid";
    in {
        home = {
            username = "nuclear-squid";
            homeDirectory = homeDir;
            stateVersion = "24.11";
            packages = with pkgs; [ ];
        };

        xdg = {
            configHome = "${homeDir}/.config";
            enable = true;
        };
        programs.rofi = {
            enable = true;
            theme = ../../rofi_theme.rasi;
        };

        programs.cava.enable = true;
    };
}

