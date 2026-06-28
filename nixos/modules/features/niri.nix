{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, ... }: let
    unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs.niri = {
      enable = true;
      package = unstable.niri;
    };

    environment.systemPackages = with unstable; [
      swaybg
      noctalia-shell
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      configPackages = [ pkgs.niri ];
    };

    services.upower.enable = true; # needed by the battery widget of noctalia
  };
}
