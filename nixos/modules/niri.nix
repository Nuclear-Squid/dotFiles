{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: let
    unstable = import inputs.unstable { system = pkgs.stdenv.hostPlatform.system; };
  in {
    programs.niri = {
      enable = true;
      package = unstable.niri;
    };

    environment.systemPackages = with unstable; [
      noctalia-shell  # Fancy rice things, like bar, launcher or widgets
      swaybg  # Quick background image setter
      xwayland-satellite # xorg apps support for niri / wayland
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      configPackages = [ pkgs.niri ];
    };

    services.upower.enable = true; # needed by the battery widget of noctalia

    # Forgot why I even needed this library
    # environment.variables.LD_LIBRARY_PATH = [ (lib.makeLibraryPath pkgs.libxcursor) ];

    gtk = {
      enable = true;
      colorScheme = "dark";
      theme = {
        name = "Kanagawa-B";
        package = pkgs.kanagawa-gtk-theme;
      };
    };
  };
}
