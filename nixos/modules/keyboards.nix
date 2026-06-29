{ self, inputs, ... }: {
  flake.nixosModules.keyboards = { pkgs, lib, ... }: let
    unstable = import inputs.unstable { system = pkgs.stdenv.hostPlatform.system; };
    dotFilesRoot = ../..;
  in {
    environment.systemPackages = with unstable; [
      kanata
      qmk
      chrysalis
    ];

    services.kanata = {
      enable = true;
      package = unstable.kanata;
      keyboards.laptop = {
        devices = [ "/dev/input/event0" ];
        config = builtins.readFile (dotFilesRoot + /kanata.kbd);
        extraDefCfg = ''
          sequence-input-mode hidden-delay-type
          process-unmapped-keys yes
          concurrent-tap-hold yes
          chords-v2-min-idle 120
        '';
      };
    };
  };
}
