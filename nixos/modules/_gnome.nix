{ self, inputs, ... }: {
  flake.nixosModules.gnome = { pkgs, lib, ... }: {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.tlp.enable = lib.mkForce false;
    # pulseaudio.enable = true;
    # pipewire.enable   = false;
  };

  flake.homeModules.gnome = { pkgs, lib, ... }: {
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };
}
