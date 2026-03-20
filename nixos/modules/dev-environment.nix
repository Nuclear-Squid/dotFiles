{ self, inputs, lib, getSystem, ... }: {
    perSystem = { self', inputs', pkgs, ... }:
    let unstable = inputs'.unstable.legacyPackages;
    in {
        packages.kitty = (inputs.wrappers.wrapperModules.kitty.apply {
            pkgs = unstable;
            extraPackages = [ unstable.nerd-fonts.fantasque-sans-mono ];
            settings = {
                font_family = "FantasqueSansM Nerd Font Mono";
                font_size = 10;
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
                transparent_background_colors = "#1b1127@0.95 #231e36@0.95 #2d2a45@0.95 #373354@0.95";
                map = [
                    "ctrl+c copy_or_interrupt"
                    "ctrl+v paste_from_clipboard"
                ];
            };
        }).wrapper;

        packages.git =
        let delta = unstable.delta;
        in (inputs.wrappers.wrapperModules.git.apply {
            pkgs = unstable;
            extraPackages = [ delta ];
            settings = {
                lfs.enable = true;
                push.autoSetupRemote = true;
                core.pager = lib.getExe delta;
                interactive.diffFilter = "${lib.getExe delta} --color-only";
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
        }).wrapper;
    };

    flake.nixosModules.dev-environment = { pkgs, config, wrappers, ... }:
    let unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        self-pkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in {
        environment.systemPackages = with pkgs; [
            unstable.neovim
            self-pkgs.kitty
            self-pkgs.git
        ];
    };

    flake.homeModules.dev-environment = { pkgs, ... }:
    let unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        self-pkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in {
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

        programs.gh = {
            enable = true;
            extensions = [ pkgs.gh-notify ];
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
            enableFishIntegration = true;
            defaultCommand = "fd --type f --strip-cwd-prefix";

            # ctrl-t
            fileWidgetCommand = "fd --type f --type d --strip-cwd-prefix";
            fileWidgetOptions = [
                "--preview 'bat --color=always --style=plain -r :200 {}'"
            ];
        };
    };
}
