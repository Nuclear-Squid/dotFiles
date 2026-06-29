{ self, inputs, ... }: {
  perSystem = { config, pkgs, ... }: let
    wrappers = inputs.wrapper-modules.wrappers;
  in {
    packages.kitty = wrappers.kitty.wrap {
      font = {
        name = "FantasqueSansM Nerd Font Mono";
        # name = "Operator-caska";
        size = 10;
      };
      settings = {
        bell_path = "~/Code/dotFiles/Windows_XP_Error_sound_effect.wav";
        cursor = "#666666";
        background_opacity = "0.8";
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
        transparent_background_colors = "#1b1127@0.85 #231e36@0.85 #2d2a45@0.85 #373354@0.85";
      };
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+backspace" = "send_text all \\x17";     # ctrl  + backspace
        "shift+enter" = "send_text all \\x1b[13;2u";  # shift + enter
      };
    };
  };

  flake.nixosModules.dev-environment = { pkgs, config, ... }: let
    unstable = import inputs.unstable { system = pkgs.stdenv.hostPlatform.system; };
    self-pkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = {
      code-editors = with unstable; [
        neovim
        self-pkgs.kitty
      ];

      languages-and-compilers = with unstable; [
        cargo
        scilab-bin
        python3
        clang
      ];

      cli-tools = with unstable; [
        fd
        ripgrep
        lazygit
        onefetch
      ];

      lsp-servers = with pkgs; [
        arduino-language-server
        clang-tools
        languagetool
        ltex-ls-plus
        ltex-ls
        ty
      ];

      dev-tools = with pkgs; [
        valgrind
        gnumake
        cmake
        serie
        act  # Build GitHub’s CI locally
        nginx
      ];

      should-go-in-ergol-repo = with unstable; [
        hugo
        pandoc
      ];
    }
    |> builtins.attrValues
    |> builtins.concatLists
    ;

    environment.variables = {
      EDITOR = "nvim";
      EXA_COLORS = "di=01;35:uu=03;33:ur=33:uw=33:gw=33:gx=01;32:tw=33:tx=01;32:sn=35";
    };

    fonts.packages = with pkgs.nerd-fonts; [
      fantasque-sans-mono
      monaspace
    ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings  = true;
      recommendedOptimisation  = true;
      recommendedProxySettings = true;
      recommendedTlsSettings   = true;

      virtualHosts.localhost = {
        # addSSL = true;
        # enableACME = true;
        # default = true;
        root = "${config.users.users.nuclear-squid.home}/Code/www/";
        # locations."/var/html/".proxyPass = "http://localhost:8000";
      };
      # appendHttpConfig = "listen 127.0.0.1:80";
    };

    # Upload programs to Mbed arduino boards
    services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2e8a", MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1fc9", MODE:="0666"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0525", MODE:="0666"
    '';

    programs.fish.enable = true;

    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

    virtualisation.waydroid.enable = true;
    networking.nftables.enable = true; # Needed by waydroid
  };

  flake.homeModules.dev-environment = { pkgs, ... }: let
    unstable = import inputs.unstable { system = pkgs.stdenv.hostPlatform.system; };
    dotFilesRoot = ../..;
  in {
    programs.neovide = {
      enable = true;
      package = unstable.neovide;
      settings.backtraces_path = "$HOME/.local/share/neovide";
      settings.font = {
        size = 16;
        normal        = { family = "FantasqueSansM Nerd Font Mono"; style = "regular"; };
        bold          = { family = "FantasqueSansM Nerd Font Mono"; style = "bold";    };
        italic        = { family = "MonaspiceRn Nerd Font Mono";    style = "regular"; };
        bold_italic   = { family = "MonaspiceRn Nerd Font Mono";    style = "italic";  };
      };
    };

    programs.git = {
      enable = true;
      lfs.enable = true;

      settings = {
        push.autoSetupRemote = true;

        user = {
          name = "Nuclear-Squid";
          email = "leo@cazenave.cc";
        };

        alias = {
          cv = "commit -v";
          cb = "checkout -b";
          st = "status";
          lo = "log --graph --oneline";
          pf = "push --force-with-lease";
        };
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.gh = {
      enable = true;
      extensions = [ pkgs.gh-notify ];
    };

    # programs.kitty = {
    #   enable = true;
    #   package = unstable.kitty;
    #   font = {
    #     name = "FantasqueSansM Nerd Font Mono";
    #     # name = "Operator-caska";
    #     size = 10;
    #   };
    #   settings = {
    #     bell_path = "~/Code/dotFiles/Windows_XP_Error_sound_effect.wav";
    #     cursor = "#666666";
    #     background_opacity = "0.8";
    #     foreground = "#f7dec7";
    #     background = "#1a0c24";
    #     color0  = "#373354";
    #     color1  = "#c02030";
    #     color2  = "#3bb846";
    #     color3  = "#dd9046";
    #     color4  = "#2a68c8";
    #     color5  = "#b02cc0";
    #     color6  = "#48d5aa";
    #     color7  = "#9C9BBA";
    #     color8  = "#4b4673";
    #     color9  = "#e86671";
    #     color10 = "#8ebd6b";
    #     color11 = "#e5c07b";
    #     color12 = "#5ab0f6";
    #     color13 = "#c678dd";
    #     color14 = "#48d5aa";
    #     color15 = "#f5d9de";
    #     transparent_background_colors = "#1b1127@0.85 #231e36@0.85 #2d2a45@0.85 #373354@0.85";
    #   };
    #   keybindings = {
    #     "ctrl+c" = "copy_or_interrupt";
    #     "ctrl+backspace" = "send_text all \\x17";     # ctrl  + backspace
    #     "shift+enter" = "send_text all \\x1b[13;2u";  # shift + enter
    #   };
    # };

    programs.zoxide = {
      enable = true;
      options = [ "--cmd" "t" ];
    };

    programs.fish = {
      enable = true;
      shellInit = builtins.readFile (dotFilesRoot + /shell/fish_config.fish);
      shellInitLast = ''
            functions --copy t zoxide_wrapper
            function t --wraps=t
                zoxide_wrapper $argv
                git_repo_changed && clear && onefetch
                magic_ls
                nix_flake_available && nix develop
            end

            functions --copy ti zoxide_interactive_wrapper
            function ti --wraps=ti
                zoxide_interactive_wrapper $argv
                git_repo_changed && clear && onefetch
                magic_ls
                nix_flake_available && nix develop
            end
      '';
    };

    programs.starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[|>](bold green)";
          error_symbol   = "[!!](bold red)";
        };

        directory.truncation_length = 5;
      };
    };

    programs.fastfetch.enable = true;

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--git"
        "--icons"
        "--no-quotes"
      ] ;
    };

    programs.bat.enable = true;
    programs.yazi.enable = true;

    programs.fzf = rec {
      enable = true;
      package = unstable.fzf;
      enableFishIntegration = true;
      defaultCommand = "fd --type f --strip-cwd-prefix";

      # ctrl-t
      fileWidgetCommand = "fd --type f --type d --strip-cwd-prefix";
      fileWidgetOptions = [
        "--preview 'bat --color=always --style=plain -r :200 {}'"
      ];
    };

    programs.nh = {
      enable = true;
      flake = dotFilesRoot + /nixos;
    };

    programs.tealdeer = {
      enable = true;
      enableAutoUpdates = true;
    };
  };
}
