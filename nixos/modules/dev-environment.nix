{ inputs, ... }: {
    flake.nixosModules.dev-environment = { pkgs, ... }:
    let unstable   = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        old-stable = inputs.old-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
        environment.systemPackages = with pkgs; [
            unstable.neovim
            unstable.lazygit
        ];
    };
}
