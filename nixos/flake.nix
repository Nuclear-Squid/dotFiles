{
  description = "My laptop system confituration";
  inputs = {
    nixpkgs.url    = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url   = "github:nixos/nixpkgs/nixos-unstable";
    old-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
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

  outputs = { nixpkgs, ... } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix

        ({ pkgs, ...}: {
          environment.systemPackages = [
            inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
          ];
        })
      ];
    };
  };
}
