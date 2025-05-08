{
  description = "My laptop system confituration";
  inputs = {
    nixpkgs.url    = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url   = "github:nixos/nixpkgs/nixos-unstable";
    old-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, ... } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
