{ config, pkgs, lib, ... }:
let
    unstable   = import <nixos-unstable>   {};
    old-stable = import <nixos-old-stable> {};
    homeDir = "/home/nuclear-squid";
in {
    home = {
        username = "nuclear-squid";
        homeDirectory = homeDir;
        stateVersion = "24.11";
        packages = with pkgs; [ picom ];
    };

    xdg = {
        configHome = "${homeDir}/.config";
        # configFile.picom.text = builtins.readFile ../picom.conf;
        enable = true;
        configFile."picom/picom.conf" = {
            source = config.lib.file.mkOutOfStoreSymlink ../picom.conf;
            force = true;
        };
    };

    systemd.user.services.picom =
        let cfg_systemd_target = "graphical-session.target";
        in {
        Unit = {
            Description = "Picom X11 compositor";
            After = [ cfg_systemd_target ];
            PartOf = [ cfg_systemd_target ];
        };
        Install = {
            WantedBy = [ cfg_systemd_target ];
        };
        Service = {
            ExecStart = lib.concatStringsSep " " [
                "${lib.getExe pkgs.picom}"
                    # "--config ${config.xdg.configFile."picom/picom.conf".source}"
                    "--config ${homeDir}/.config/picom/picom.conf"
            ];
        };
    };

    programs.neovide = {
        enable = true;
        package = unstable.neovide;
        settings.backtraces_path = "$HOME/.local/share/neovide";
        settings.font = {
            size = 16;
            normal        = { family = "FantasqueSansM Nerd Font Mono"; style = "regular"; };
            bold          = { family = "FantasqueSansM Nerd Font Mono"; style = "bold"; };
            italic        = { family = "MonaspiceRn Nerd Font Mono";    style = "regular"; };
            bold_italic   = { family = "MonaspiceRn Nerd Font Mono";    style = "italic"; };
        };
    };

    programs.git = {
        enable = true;
        lfs.enable = true;
        userName = "Nuclear-Squid";
        userEmail = "leo@cazenave.cc";
        extraConfig.push.autoSetupRemote = true;
        aliases = {
            cv = "commit -v";
            cb = "checkout -b";
            st = "status";
            lo = "log --graph --oneline";
            pf = "push --force-with-lease";
        };
    };

    programs.gh = {
        enable = true;
        extensions = [ pkgs.gh-notify ];
    };

    programs.alacritty = {
        enable = true;
        settings = {
            font = {
                size = 7;
                # normal.family = "Operator-caska";
                normal        = { family = "FantasqueSansM Nerd Font Mono"; style = "regular"; };
                bold          = { family = "FantasqueSansM Nerd Font Mono"; style = "bold"; };
                italic        = { family = "MonaspiceRn Nerd Font Mono";    style = "regular"; };
                bold_italic   = { family = "MonaspiceRn Nerd Font Mono";    style = "italic"; };
            };
            window = {
                opacity = 0.9;
                blur = true;
            };
            colors = {
                primary = {
                    foreground = "#f7dec7";
                    background = "#1a0c24";
                };
                normal = {
                    black   = "#373354";
                    red     = "#c02030";
                    green   = "#3bb846";
                    yellow  = "#dd9046";
                    blue    = "#2a68c8";
                    magenta = "#b02cc0";
                    cyan    = "#48d5aa";
                    white   = "#9C9BBA";
                };
                bright = {
                    black   = "#4b4673";
                    red     = "#e86671";
                    green   = "#8ebd6b";
                    yellow  = "#e5c07b";
                    blue    = "#5ab0f6";
                    magenta = "#c678dd";
                    cyan    = "#48d5aa";
                    white   = "#f5d9de";
                };
                transparent_background_colors = true;
            };
            selection.save_to_clipboard = true;
        };
    };

    programs.kitty = {
        enable = true;
        package = unstable.kitty;
        font = {
            name = "FantasqueSansM Nerd Font Mono";
            # name = "Operator-caska";
            size = 10;
        };
        settings = {
            bell_path = "~/Code/dotFiles/Windows_XP_Error_sound_effect.wav";
            cursor = "#666666";
            background_opacity = "0.9";
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
        };
        keybindings = {
            "ctrl+c" = "copy_or_interrupt";
            "ctrl+backspace" = "send_text all \\x17";     # ctrl  + backspace
            "shift+enter" = "send_text all \\x1b[13;2u";  # shift + enter
        };
    };

    programs.zoxide = {
        enable = true;
        options = [ "--cmd" "t" ];
    };

    programs.fish = {
        enable = true;
        shellInit = builtins.readFile ../shell/fish_config.fish;
        interactiveShellInit = ''
            functions --copy t zoxide_wrapper
            function t --wraps=t
                zoxide_wrapper $argv
                git_repo_changed && onefetch
                magic_ls
            end

            functions --copy ti zoxide_interactive_wrapper
            function ti --wraps=ti
                zoxide_interactive_wrapper $argv
                git_repo_changed && onefetch
                magic_ls
            end
        '';
    };

    programs.zsh = rec {
        enable = false;
        enableCompletion = true;
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
            builtins.readFile ../shell/utils.sh
            + builtins.readFile ../shell/aliases.sh
            + builtins.readFile ../shell/zsh_config.sh
            ;
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
        enableZshIntegration = true;
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
        enableFishIntegration = true;
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
