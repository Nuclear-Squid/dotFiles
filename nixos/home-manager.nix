{ config, pkgs, ... }:
let
home-manager-version = "23.11";
home-manager = builtins.fetchTarball"https://github.com/nix-community/home-manager/archive/release-${home-manager-version}.tar.gz";
in {
    imports = [
        (import "${home-manager}/nixos")
    ];

    nix = {
        package = pkgs.nix;
        settings.experimental-features = [ "nix-command" "flakes" ];
    };

    home-manager.users.nuclearsquid = {
        home.stateVersion = home-manager-version;
        programs.git = {
            enable = true;
            lfs.enable = true;
            userName = "Nuclear-Squid";
            userEmail = "leo@cazenave.cc";
            aliases = {
                cv = "commit -v";
                cb = "checkout -b";
                st = "status";
                log = "log --graph --oneline";
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

        programs.zsh = rec {
            enable = true;
            enableCompletion = true;
            enableAutosuggestions = true;
            syntaxHighlighting.enable = true;
            syntaxHighlighting.styles.path = "fg=cyan";
            autocd = true;

            history = {
                size = 10000;
                path = "/home/nuclearsquid/.zsh_history";
            } ;

            # I know there’s a 'shellAliases' property here, but this
            # file also has functions I want syntax highlighting for.
            initExtra = ''
                zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
            '' + builtins.readFile ../shell_aliases.sh;
        };

        programs.thefuck = {
            enable = true;
            enableZshIntegration = true;
        };

        programs.tmux = {
            enable = true;
            shell = "${pkgs.zsh}/bin/zsh";
            mouse = true;
            shortcut = "a";
            terminal = "tmux-256color";
            extraConfig = "set -g status off";

            plugins = with pkgs.tmuxPlugins; [
                sensible
            ];
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

        programs.eza = {
            enable = true;
            # enableZshIntegration = true;
            git = true;
            icons = true;
            extraOptions = [
                "--group-directories-first"
                "--git"
                "--icons"
                "--no-quotes"
            ] ;
        };

        programs.bat.enable = true;

        programs.fzf = rec {
            enable = true;
            enableZshIntegration = true;
            tmux.enableShellIntegration = true;
            tmux.shellIntegrationOptions = [ "-p 80%,80%" ];
            defaultCommand = "fd --type f --strip-cwd-prefix";

            # ctrl-t
            fileWidgetOptions = [
                "--preview 'bat --color=always --style=plain -r :200 {}'"
            ];
        };

        programs.rofi = {
            enable = true;
            theme = ../rofi_theme.rasi;
        };

        services.polybar = {
            enable = true;
            config = ../polybar/config.ini;
            package = pkgs.polybar.override { i3Support = true; };
            script = "";
        };
    };
}
