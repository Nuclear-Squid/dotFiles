{ self, inputs, ... }: {
  flake.nixosModules.desktop-apps = { pkgs, lib, ... }: let
    unstable = import inputs.unstable {
      system = pkgs.stdenv.hostPlatform.system;
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
      ];
    };
  in{
    programs.steam = {
      enable = true;
      package = unstable.steam;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    environment.systemPackages = with pkgs; [
      # Web browsers
      firefox
      tor-browser
      inputs.zen-browser.packages.x86_64-linux.default

      # Needed for work
      thunderbird
      picoscope

      # File explorers
      thunar
      pcmanfm

      simplescreenrecorder
      # Libreoffice + libs
      libreoffice-qt
      hunspell
      hunspellDicts.uk_UA
      hunspellDicts.th_TH

      # Chat
      element-desktop
      discord
      telegram-desktop
      signal-desktop
      zulip
      zulip-term

      # Music
      spotify
      ardour

      # Art / Graphic design
      kdePackages.kdenlive
      # unstable.musescore
      # unstable.muse-sounds-manager
      inkscape
      unstable.blender
      unstable.krita
      unstable.gimp

      # Games / Steam related
      protontricks  # For Steam proton
      unstable.olympus  # Celeste mod installer

      # from the cmd-line but it’s a GUI so it counts
      llpp
      feh
    ];
  };

  flake.homeModules.desktop-apps = { pkgs, lib, ... }: let
    unstable = import inputs.unstable { system = pkgs.stdenv.hostPlatform.system; };
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

