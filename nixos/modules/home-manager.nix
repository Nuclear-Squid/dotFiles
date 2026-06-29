{ self, inputs, ... }: {
  # This is your module that imports and configures home-manager
  flake.nixosModules.HomeManager = { pkgs, ... }: {
    imports = [
      inputs.home-manager.nixosModules.default # import official home-manager NixOS module
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.nuclear-squid = self.homeModules.nuclear-squid;
    };

    users.defaultUserShell = pkgs.fish;
    users.users.nuclear-squid = {
      isNormalUser = true;
      description = "Nuclear Squid";
      extraGroups = [
        "networkmanager"
        "audio"
        "wheel"    # Enable 'sudo' for the user.
        "dialout"  # Allow access to serial device (for Arduino dev)
        "docker"   # Allow using docker without root access
        "nginx"    # Allow using nginx in localhost
      ];
    };
  };

  # This is your standalone home-manager configuration, meant to be used on non-nixos machines
  # with the home-manager command
  flake.homeConfigurations.nuclear-squid = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [ self.homeModules.nuclear-squid ];
  };

  # This is your home.nix, your module where you configure home-manager
  # It's imported both in standalone configuration above, and in your nixos configuration
  flake.homeModules.nuclear-squid = { pkgs, lib, ... }: let
    unstable = import inputs.unstable { system = pkgs.stdenv.hostPlatform.system; };
    homeDir = "/home/nuclear-squid";
    dotFilesRoot = ../../..;
  in {
    imports = [
      self.homeModules.i3
      self.homeModules.niri
      self.homeModules.dev-environment
      self.homeModules.desktop-apps
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

    services.polkit-gnome.enable = true; # polkit
  };
}
