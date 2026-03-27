{
  description = "My laptop system confituration";
  inputs = {
    nixpkgs.url    = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url   = "github:nixos/nixpkgs/nixos-unstable";
    old-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "unstable";
    };

    prismlauncher.url = "github:PrismLauncher/PrismLauncher";

    # jay-compositer = {
    #   url = "github:Yappaholic/jay-nixos";
    #   inputs.nixpkgs.follows = "unstable";
    # };
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix

        ({ pkgs, ...}: {
          environment.systemPackages = [
            inputs.prismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.prismlauncher
          ];
        })

        home-manager.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.nuclear-squid = ./home.nix;
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = ".hm_backup";
          };
        }
      ];
    };

    homeConfigurations.nuclear-squid = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./home.nix ];
    };

    templates.basic_shell = {
      path = ./basic_shell;
      description = "Boiler-plate around nix shell in a flake";
      welcomeText = "Flake initialized, go ham, go nutz";
    };
  };
}
