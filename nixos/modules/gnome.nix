{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
  };

  flake.homeModules.gnome = { pkgs, lib, ... }: {
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };
}
