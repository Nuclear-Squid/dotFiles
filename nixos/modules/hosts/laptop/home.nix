{ self, inputs, ... }: {

  # This is your standalone home-manager configuration, meant to be used on non-nixos machines
  # with the home-manager command
  flake.homeConfigurations.nucelar-squid = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [ self.homeModules.nuclear-squid ];
  };

  # This is your home.nix, your module where you configure home-manager
  # It's imported both in standalone configuration above, and in your nixos configuration
  flake.homeModules.nuclear-squid = { pkgs, ... }:
  let homeDir = "/home/nuclear-squid";
  in {
    programs.bash.enable = true;
    programs.bash.shellAliases.ll = "ls -l";

    home = {
      username = "nuclear-squid";
      homeDirectory = homeDir;
      packages = [ pkgs.hello ];
      stateVersion = "24.11";
    };
  };
}
