{
    description = "My laptop system confituration";
    inputs = {
        nixpkgs.url    = "github:nixos/nixpkgs/nixos-25.11";
        unstable.url   = "github:nixos/nixpkgs/nixos-unstable";
        old-stable.url = "github:nixos/nixpkgs/nixos-25.05";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        flake-parts.url = "github:hercules-ci/flake-parts";
        import-tree.url = "github:vic/import-tree";
        wrappers.url    = "github:Lassulus/wrappers";

        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "unstable";
        };

        prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    };

    outputs = { flake-parts, import-tree, home-manager, nixpkgs, ... } @ inputs:
        flake-parts.lib.mkFlake { inherit inputs; } {
            systems = [ "x86_64-linux" ];
            imports = [
                home-manager.flakeModules.home-manager
                ./hosts/laptop.nix
                (import-tree ./modules)
            ];

            flake.homeConfigurations.nuclear-squid = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "x86_64-linux"; };
                modules = [
                    inputs.self.homeModules.niri
                    inputs.self.homeModules.i3
                    inputs.self.homeModules.common
                    inputs.self.homeModules.dev-environment
                    inputs.self.homeModules.gui
                ];
            };
        };

}
