{ self, inputs, ... }: {
  flake.nixosModules.desktop-apps = { pkgs, lib, ... }: let
    unstable = import inputs.unstable {
      system = pkgs.stdenv.hostPlatform.system;
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
        "ltspice"
      ];
    };
  in{
    programs.steam = {
      enable = true;
      package = unstable.steam;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    environment.systemPackages = {
      web-browsers = with unstable; [
        firefox
        tor-browser
        inputs.zen-browser.packages.x86_64-linux.default
      ];

      boring-work-shit = with pkgs; [
        thunderbird
        picoscope
        unstable.ltspice
        unstable.kicad
      ];

      file-explorers = with unstable; [
        thunar
        pcmanfm
      ];

      libreoffice-and-libs = with pkgs; [
        libreoffice-qt
        hunspell
        hunspellDicts.uk_UA
        hunspellDicts.th_TH
      ];

      chat = with pkgs; [
        element-desktop
        discord
        telegram-desktop
        signal-desktop
        zulip
        zulip-term
      ];

      music = with pkgs; [
        spotify
        ardour
        musescore
        muse-sounds-manager
      ];

      art-and-graphic-design = with unstable; [
        kdePackages.kdenlive
        inkscape
        blender
        krita
        gimp
      ];

      games-related = with unstable; [
        protontricks  # For Steam proton
        olympus  # Celeste mod installer
        inputs.prismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.prismlauncher # Modded-Minecraft launcher
      ];

      miscellaneous = with pkgs; [
        llpp
        feh
        simplescreenrecorder
      ];
    }
    |> builtins.attrValues
    |> builtins.concatLists
    ;
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

