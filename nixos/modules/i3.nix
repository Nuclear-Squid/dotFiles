{ self, inputs, ... }: {
  flake.nixosModules.i3 = { pkgs, ... }: let
    unstable = import inputs.unstable { system = pkgs.stdenv.hostPlatform.system; };
    dotFilesRoot = ../..;
  in {
    services.xserver = {
      enable = true;
      xkb.layout  = "fr";
      xkb.variant = "ergol";
      # xkb.options = "compose:102";
      xkb.options = "hyper:mod4";

      # videoDrivers = [ "intel" ];

      desktopManager.xterm.enable = false;

      windowManager.i3 = {
        enable = true;
        package = unstable.i3.overrideAttrs {
          patches = [ (dotFilesRoot + /i3/0001-Added-option-to-hide-title-bar-on-tabs-and-staks.patch) ];
          doCheck = false;
        };
      };

      # displayManager.sessionCommands = ''
      #   ${pkgs.xmodmap}/bin/xmodmap -e "remove mod3 = Hyper_L"
      #   ${pkgs.xmodmap}/bin/xmodmap -e "add mod4 = Hyper_L"
      # '';
    };

    environment.systemPackages = with pkgs; [
        xfce4-screenshooter
    ];

    environment.pathsToLink = [
      "/libexec"
    ];
  };

  flake.homeModules.i3 = { pkgs, lib, ... }: let
    dotFilesRoot = ../..;
  in {
    programs.rofi = {
      enable = true;
      theme = dotFilesRoot + /rofi_theme.rasi;
    };

    services.polybar = {
      enable = true;
      config = dotFilesRoot + /polybar/config.ini;
      package = pkgs.polybar.override { i3Support = true; };
      script = "";
    };
  };
}
