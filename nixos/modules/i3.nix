{ self, inputs, ... }: {
    flake.nixosModules.i3 = { pkgs, ... }:
    let unstable  = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        self-pkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
        customI3  = true;
    in {
        environment.pathsToLink = [ "/libexec" ];

        services.xserver = {
            enable = true;
            xkb.layout  = "fr";
            xkb.variant = "ergol";
            xkb.options = "compose:102";

            # videoDrivers = [ "intel" ];
            desktopManager.xterm.enable = false;

            windowManager.i3 = {
                enable = true;
                package =
                    if customI3
                    then unstable.i3.overrideAttrs {
                        patches = [ ../i3/0001-Added-option-to-hide-title-bar-on-tabs-and-staks.patch ];
                        doCheck = false;
                    }
                    else unstable.i3-rounded;
            };

            displayManager.sessionCommands = ''
                ${pkgs.xorg.xmodmap}/bin/xmodmap -e "remove mod3 = Hyper_L"
                ${pkgs.xorg.xmodmap}/bin/xmodmap -e "add mod4 = Hyper_L"
            '';
        };
    };

    # flake.homeModules.niri = { pkgs, ... }: {
    #     programs.niriswitcher.enable = true;
    # };
}

