{ inputs, ... }: {
    imports = [
        inputs.self.homeModules.niri
        inputs.self.homeModules.i3
        inputs.self.homeModules.common
        inputs.self.homeModules.dev-environment
        inputs.self.homeModules.gui
    ];
}

