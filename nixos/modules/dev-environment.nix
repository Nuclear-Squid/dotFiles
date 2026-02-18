{ self, inputs, ... }: {
    perSystem = { inputs', pkgs, ... }:
    let unstable = inputs'.unstable.legacyPackages;
    in {
        packages.kitty = (inputs.wrappers.wrapperModules.kitty.apply {
            pkgs = unstable;
            settings = {
                bell_path = "~/Code/dotFiles/Windows_XP_Error_sound_effect.wav";
                cursor = "#666666";
                background_opacity = "0.9";
                foreground = "#f7dec7";
                background = "#1a0c24";
                color0  = "#373354";
                color1  = "#c02030";
                color2  = "#3bb846";
                color3  = "#dd9046";
                color4  = "#2a68c8";
                color5  = "#b02cc0";
                color6  = "#48d5aa";
                color7  = "#9C9BBA";
                color8  = "#4b4673";
                color9  = "#e86671";
                color10 = "#8ebd6b";
                color11 = "#e5c07b";
                color12 = "#5ab0f6";
                color13 = "#c678dd";
                color14 = "#48d5aa";
                color15 = "#f5d9de";
            };
        }).wrapper;
    };

    flake.nixosModules.dev-environment = { pkgs, wrappers, ... }:
    let unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
        environment.systemPackages = with pkgs; [
            unstable.neovim
            unstable.lazygit
            self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
        ];
    };
}
