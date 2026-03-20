{ self, inputs, ... }: {
    flake.nixosModules.niri = { pkgs, ... }:
    let unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        self-pkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in {
        programs.niri = {
            enable = true;
            package = unstable.niri;
        };

        environment.systemPackages = with pkgs; [
            xwayland-satellite # xwayland support
            libxcursor # needed by Niri for some reason ?
            swaybg
        ];

        environment.variables.LD_LIBRARY_PATH =
            "${pkgs.lib.makeLibraryPath [ pkgs.libxcursor ]}:$LD_LIBRARY_PATH";


        xdg.portal = {
            enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
            configPackages = [ pkgs.niri ];
        };
    };

    flake.homeModules.niri = { pkgs, ... }: {
        programs.niriswitcher.enable = true;
        programs.waybar.enable = true;
        services.mako.enable = true; # notification daemon

        programs.rofi = {
            enable = true;
            theme = ../rofi_theme.rasi;
        };
    };
}

