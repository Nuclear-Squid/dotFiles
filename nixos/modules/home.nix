{ self, inputs, ... }: {
    flake.nixosModules.home = { pkgs, ... }: {
        imports = [
            self.homeModules.i3
            self.homeModules.niri
            self.homeModules.common
            self.homeModules.dev-environment
            self.homeModules.gui
        ];
    }
}

