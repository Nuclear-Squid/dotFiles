{ config, pkgs, ... }:
let
    unstable = import <nixos-unstable> { config = config.nixpkgs.config; };
in {
    home = {
        username = "nuclear-squid";
        homeDirectory = "/home/nuclear-squid";
        stateVersion = "24.05";
    };

    programs.home-manager.enable = true;

    programs.ncspot.enable = true;

    programs.git = {
        enable = true;
        lfs.enable = true;
        userName = "Nuclear-Squid";
        userEmail = "leo@cazenave.cc";
        aliases = {
            cv = "commit -v";
            cb = "checkout -b";
            st = "status";
            lo = "log --graph --oneline";
            pf = "push --force-with-lease";
        };
        extraConfig = {
            push = { autoSetupRemote = true; };
        };
    };

    programs.kitty = {
        enable = true;
        font = {
            name = "FantasqueSansMonoNerdFont";
            size = 10;
        };
        settings = {
            bold_font = "auto";
            italic_font = "auto";
            bold_italic_font = "auto";
            bell_path = "~/Code/dotFiles/Windows_XP_Error_sound_effect.wav";
            cursor = "#666666";
            background_opacity = "0.9";
            foreground = "#f7dec7";
            background = "#120b14";
            color0 = "#58424a";
            color8 = "#b7859e";
            color1 = "#bd1b30";
            color9 = "#ef2447";
            color2  = "#4fcf40";
            color10 = "#a5e443";
            color3  = "#f1a340";
            color11 = "#eed656";
            color4  = "#296ece";
            color12 = "#658cf5";
            color5  = "#c62ccc";
            color13 = "#e65bf5";
            color6  = "#48d5aa";
            color14 = "#4debda";
            color7  = "#f8d4d4";
            color15 = "#f5d9de";
        };
        keybindings = {
            "ctrl+c" = "copy_or_interrupt";
            "ctrl+backspace" = "send_text all \\x17";     # ctrl  + backspace
            "shift+enter" = "send_text all \\x1b[13;2u";  # shift + enter
        };
    };

    programs.zoxide.enable = true;

    programs.zsh = rec {
        enable = true;
        enableCompletion = true;
        # enableAutosuggestions = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        syntaxHighlighting.styles.path = "fg=cyan";
        autocd = true;

        history = {
            size = 10000;
            path = "/home/nuclear-squid/.zsh_history";
        } ;

        initExtraFirst = builtins.readFile ../shell/dumb_autorun.sh;

        initExtra =
            builtins.readFile ../shell/aliases.sh
            + builtins.readFile ../shell/zsh_config.sh
            ;
    };

    programs.thefuck = {
        enable = true;
        enableZshIntegration = true;
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
        # enableZshIntegration = true;
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
        enableZshIntegration = true;
        defaultCommand = "fd --type f --strip-cwd-prefix";

        # ctrl-t
        fileWidgetCommand = "fd --type f --type d --strip-cwd-prefix";
        fileWidgetOptions = [
            "--preview 'bat --color=always --style=plain -r :200 {}'"
        ];
    };

    programs.rofi = {
        enable = true;
        theme = ../rofi_theme.rasi;
    };

    programs.librewolf = {
        enable = true;
        # package = unstable.librewolf;
        settings = {
            "webgl.disabled" = false;
            "identity.fxaccounts.enable" = true;
            "privacy.resistFingerprinting" = true;
            "privacy.clearOnShutdown.history" = true;
            "privacy.clearOnShutdown.cookies" = true;
        };
    };

    programs.cava.enable = true;

    services.polybar = {
        enable = true;
        config = ../polybar/config.ini;
        package = pkgs.polybar.override { i3Support = true; };
        script = "";
    };

    services.dunst.enable = true;
}
