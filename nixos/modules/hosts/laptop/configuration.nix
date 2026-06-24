{ self, inputs, ... }: {

  # This is your system configuration entry-point
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laptopModule
      self.nixosModules.HomeManager
    ];
  };

  # This is your configuration.nix, a place where you configure your system
  # You can place it in a separate file.
  flake.nixosModules.laptopModule = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.vim
      pkgs.firefox
    ];

    users.users.nuclear-squid = {
      isNormalUser = true;
      shell = pkgs.fish;
    };
    home-manager.users.nuclear-squid = self.homeModules.nuclear-squid;
  };

}
