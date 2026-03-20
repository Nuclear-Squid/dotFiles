{ self, inputs, ... }: {
    flake.nixosModules.common = { pkgs, config, wrappers, ... }:
    let unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        self-pkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in {
        services = {
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

        services.polkit-gnome.enable = true; # No idea what it does

        # GUI app launcher, used by both I3 and Niri
        programs.rofi = {
            enable = true;
            theme = ../rofi_theme.rasi;
        };

        programs.cava.enable = true;
    };
}

