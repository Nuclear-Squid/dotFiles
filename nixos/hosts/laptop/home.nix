{ self, inputs, ... }: {

  # This is your standalone home-manager configuration, meant to be used on non-nixos machines
  # with the home-manager command
  flake.homeConfigurations.nuclear-squid = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [ self.homeModules.nuclear-squid ];
  };

  # This is your home.nix, your module where you configure home-manager
  # It's imported both in standalone configuration above, and in your nixos configuration
  flake.homeModules.nuclear-squid = { pkgs, lib, ... }: let
    unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    homeDir = "/home/nuclear-squid";
    dotFilesRoot = ../../..;
  in {
    imports = [
      self.homeModules.i3
      self.homeModules.dev-environment
    ];

    home = {
      username = "nuclear-squid";
      homeDirectory = homeDir;
      stateVersion = "24.11";
    };

    xdg = {
      configHome = "${homeDir}/.config";
      enable = true;
    };

    gtk = {
      enable = true;
      colorScheme = "dark";
      theme = {
        name = "Kanagawa-B";
        package = pkgs.kanagawa-gtk-theme;
      };
    };

    services.polkit-gnome.enable = true; # polkit

    # programs.waybar.enable = true;

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

    programs.cava.enable = true;
  };
}
