{ self, inputs, ... }: {
    flake.nixosModules.gui = { pkgs, ... }:
    let unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        self-pkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in {
        environment.systemPackages = with pkgs; [
            # Instant messageing
            discord
            element-desktop
            signal-desktop
            zulip
            zulip-term

            # Music
            spotify
            # old-stable.ardour  # Stable and Unstable versions are broken.
            ardour
            unstable.musescore
            # unstable.muse-sounds-manager

            # Video / Art
            kdePackages.kdenlive
            inkscape
            blender

            # Web browsers
            inputs.zen-browser.packages.x86_64-linux.default
            firefox
            tor-browser

            # Work stuff :(
            thunderbird
            libreoffice-qt
            hunspell # Libs for libreoffice
            hunspellDicts.uk_UA
            hunspellDicts.th_TH

            # other
            simplescreenrecorder
            xfce.xfce4-screenshooter
            xfce.thunar
            picoscope
        ];
    };

    flake.homeModules.gui = { pkgs, ... }:
    let homeDir = "/home/nuclear-squid";
    in {
        programs.librewolf = {
            enable = true;
            # package = unstable.librewolf;
            settings = {
                "webgl.disabled" = false;
                "identity.fxaccounts.enable" = true;
                "privacy.resistFingerprinting" = true;
                "privacy.clearOnShutdown.history" = true;
                "privacy.clearOnShutdown.cookies" = true;
            };
        };
    };
}
