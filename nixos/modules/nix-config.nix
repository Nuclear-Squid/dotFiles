{ inputs, ... }: {
  imports = [
    # adds home-manager options to flake-parts
    inputs.home-manager.flakeModules.home-manager
  ];

  config.systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  # In the `config` option, since the above `config.systems` declares this file
  # as a top-level module. Not sure if that’s an issue or not
  config.flake.nixosModules.nix-config = { pkgs, config, ... }: {
    nixpkgs.config = {
      allowUnfree = true;
      pulseaudio = true;

      permittedInsecurePackages = [
        "electron-39.8.10"  # Needed by Zulip, see https://github.com/NixOS/nixpkgs/pull/526892
      ];
    };

    nix = {
      optimise.automatic = true; # Optimise storage space of NixOS

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false; # Please stop yelling at me everytime I run `nix develop`
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
