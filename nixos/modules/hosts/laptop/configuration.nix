{ self, inputs, ... }: {

  # This is your system configuration entry-point
  flake.nixosConfigurations.HOSTNAME = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.HOSTNAMEModule
      self.nixosModules.myHomeManager
    ];
  };

  # This is your configuration.nix, a place where you configure your system
  # You can place it in a separate file.
  flake.nixosModules.HOSTNAMEModule = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.vim
      pkgs.firefox
    ];

    users.users.USERNAME = {
      isNormalUser = true;
      shell = pkgs.fish;
    };
    home-manager.users.USERNAME = self.homeModules.USERNAMEModule;
  };

}
