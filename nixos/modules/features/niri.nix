{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = unstable.niri;
    };

    upower.enable = true; # needed by the battery widget of noctalia
  };
}
