{ config, pkgs, ... }:
let
unstable = import <nixos-unstable> {};
# unstable = pkgs;
home-manager-version = "24.11";
home-manager = builtins.fetchTarball"https://github.com/nix-community/home-manager/archive/release-${home-manager-version}.tar.gz";
in {
    imports = [
        (import "${home-manager}/nixos")
    ];

    nix = {
        package = pkgs.nix;
        settings.experimental-features = [ "nix-command" "flakes" ];
    };

    home-manager.users.nuclear-squid = {
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

            # I know there’s a 'shellAliases' property here, but this
            # file also has functions I want syntax highlighting for.
            initExtra = ''
                zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

                fastfetch
            '' + builtins.readFile ../shell_aliases.sh;
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

        programs.librewolf = {
            enable = true;
            package = unstable.librewolf;
            settings = {
                "webgl.disabled" = false;
                "identity.fxaccounts.enable" = true;
                "privacy.resistFingerprinting" = true;
                "privacy.clearOnShutdown.history" = true;
                "privacy.clearOnShutdown.cookies" = true;
            };
        };

        programs.cava.enable = true;

        # services.picom.enable = true;

        services.polybar = {
            enable = true;
            config = ../polybar/config.ini;
            package = pkgs.polybar.override { i3Support = true; };
            script = "";
        };

        # services.dunst.enable = true;
        # services.dunst = {
        #     enable = true;
        #     package = unstable.dunst;

            # settings = {
            #     glo
            # };
        # };

        # services.dunst = {
        #     enable = true;
            # iconTheme = {
            #     name = config.gtk.iconTheme.name;
            #     package = config.gtk.iconTheme.package;
            #     size = "22x22";
            #   };
            # settings = {
            #   global = {
            #     monitor = 0;
            #     # Display notification on focused monitor.  Possible modes are:
            #     #   mouse: follow mouse pointer
            #     #   keyboard: follow window with keyboard focus
            #     #   none: don't follow anything
            #     #
            #     # "keyboard" needs a window manager that exports the
            #     # _NET_ACTIVE_WINDOW property.
            #     # This should be the case for almost all modern window managers.
            #     #
            #     # If this option is set to mouse or keyboard, the monitor option
            #     # will be ignored.
            #     follow = "mouse";

            #     # The geometry of the window:
            #     #   [{width}]x{height}[+/-{x}+/-{y}]
            #     # The geometry of the message window.
            #     # The height is measured in number of notifications everything else
            #     # in pixels.  If the width is omitted but the height is given
            #     # ("-geometry x2"), the message window expands over the whole screen
            #     # (dmenu-like).  If width is 0, the window expands to the longest
            #     # message displayed.  A positive x is measured from the left, a
            #     # negative from the right side of the screen.  Y is measured from
            #     # the top and down respectively.
            #     # The width can be negative.  In this case the actual width is the
            #     # screen width minus the width defined in within the geometry option.
            #     width = 800;
            #     height = 300;
            #     offset = [
            #       "-20"
            #       "48"
            #     ];
            #     # geometry = "350x100-20+48";

            #     # Show how many messages are currently hidden (because of geometry).
            #     indicate_hidden = "yes";

            #     # Shrink window if it's smaller than the width.  Will be ignored if
            #     # width is 0.
            #     shrink = "no";

            #     # The transparency of the window.  Range: [0; 100].
            #     # This option will only work if a compositing window manager is
            #     # present (e.g. xcompmgr, compiz, etc.).
            #     transparency = 15;

            #     # The height of the entire notification.  If the height is smaller
            #     # than the font height and padding combined, it will be raised
            #     # to the font height and padding.
            #     notification_height = 0;

            #     # Draw a line of "separator_height" pixel height between two
            #     # notifications.
            #     # Set to 0 to disable.
            #     separator_height = 2;

            #     # Padding between text and separator.
            #     padding = 16;

            #     # Horizontal padding.
            #     horizontal_padding = 32;

            #     # Defines width in pixels of frame around the notification window.
            #     # Set to 0 to disable.
            #     frame_width = 2;

            #     # Defines color of the frame around the notification window.
            #     frame_color = "#282a36";

            #     # Define a color for the separator.
            #     # possible values are:
            #     #  * auto: dunst tries to find a color fitting to the background;
            #     #  * foreground: use the same color as the foreground;
            #     #  * frame: use the same color as the frame;
            #     #  * anything else will be interpreted as a X color.
            #     separator_color = "frame";

            #     # Sort messages by urgency.
            #     sort = "yes";

            #     # Don't remove messages, if the user is idle (no mouse or keyboard input)
            #     # for longer than idle_threshold seconds.
            #     # Set to 0 to disable.
            #     # A client can set the 'transient' hint to bypass this. See the rules
            #     # section for how to disable this if necessary
            #     idle_threshold = 120;

            #     ### Text ###

            #     font = "CaskaydiaCove Nerd Font Propo 10";

            #     # The spacing between lines.  If the height is smaller than the
            #     # font height, it will get raised to the font height.
            #     line_height = 0;

            #     # Possible values are:
            #     # full: Allow a small subset of html markup in notifications:
            #     #        <b>bold</b>
            #     #        <i>italic</i>
            #     #        <s>strikethrough</s>
            #     #        <u>underline</u>
            #     #
            #     #        For a complete reference see
            #     #        <https://developer.gnome.org/pango/stable/pango-Markup.html>.
            #     #
            #     # strip: This setting is provided for compatibility with some broken
            #     #        clients that send markup even though it's not enabled on the
            #     #        server. Dunst will try to strip the markup but the parsing is
            #     #        simplistic so using this option outside of matching rules for
            #     #        specific applications *IS GREATLY DISCOURAGED*.
            #     #
            #     # no:    Disable markup parsing, incoming notifications will be treated as
            #     #        plain text. Dunst will not advertise that it has the body-markup
            #     #        capability if this is set as a global setting.
            #     #
            #     # It's important to note that markup inside the format option will be parsed
            #     # regardless of what this is set to.
            #     markup = "full";

            #     # The format of the message.  Possible variables are:
            #     #   %a  appname
            #     #   %s  summary
            #     #   %b  body
            #     #   %i  iconname (including its path)
            #     #   %I  iconname (without its path)
            #     #   %p  progress value if set ([  0%] to [100%]) or nothing
            #     #   %n  progress value if set without any extra characters
            #     #   %%  Literal %
            #     # Markup is allowed
            #     format = "<b>%s</b>\\n%b";
            #     # format = "<b>%s</b>\n%b";

            #     # Alignment of message text.
            #     # Possible values are "left", "center" and "right".
            #     alignment = "left";

            #     # Vertical alignment of message text and icon.
            #     # Possible values are "top", "center" and "bottom".
            #     vertical_alignment = "center";

            #     # Show age of message if message is older than show_age_threshold
            #     # seconds.
            #     # Set to -1 to disable.
            #     show_age_threshold = 60;

            #     # Split notifications into multiple lines if they don't fit into
            #     # geometry.
            #     word_wrap = "yes";

            #     # When word_wrap is set to no, specify where to make an ellipsis in long lines.
            #     # Possible values are "start", "middle" and "end".
            #     ellipsize = "middle";

            #     # Ignore newlines '\n' in notifications.
            #     ignore_newline = "no";

            #     # Stack together notifications with the same content
            #     stack_duplicates = true;

            #     # Hide the count of stacked notifications with the same content
            #     hide_duplicate_count = false;

            #     # Display indicators for URLs (U) and actions (A).
            #     show_indicators = "yes";

            #     ### Icons ###

            #     # Align icons left/right/off
            #     icon_position = "left";

            #     # Scale small icons up to this size, set to 0 to disable. Helpful
            #     # for e.g. small files or high-dpi screens. In case of conflict,
            #     # max_icon_size takes precedence over this.
            #     min_icon_size = 0;

            #     # Scale larger icons down to this size, set to 0 to disable
            #     max_icon_size = 64;

            #     # Paths to default icons.
            #     # icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/

            #     ### History ###

            #     # Should a notification popped up from history be sticky or timeout
            #     # as if it would normally do.
            #     sticky_history = "yes";

            #     # Maximum amount of notifications kept in history
            #     history_length = 20;

            #     ### Misc/Advanced ###

            #     # dmenu path.
            #     dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst:";

            #     # Browser for opening urls in context menu.
            #     browser = "${pkgs.firefox}/bin/firefox -new-tab";

            #     # Always run rule-defined scripts, even if the notification is suppressed
            #     always_run_script = true;

            #     # Define the title of the windows spawned by dunst
            #     title = "Dunst";

            #     # Define the class of the windows spawned by dunst
            #     class = "Dunst";

            #     # Print a notification on startup.
            #     # This is mainly for error detection, since dbus (re-)starts dunst
            #     # automatically after a crash.
            #     startup_notification = false;

            #     # Manage dunst's desire for talking
            #     # Can be one of the following values:
            #     #  crit: Critical features. Dunst aborts
            #     #  warn: Only non-fatal warnings
            #     #  mesg: Important Messages
            #     #  info: all unimportant stuff
            #     # debug: all less than unimportant stuff
            #     verbosity = "mesg";

            #     # Define the corner radius of the notification window
            #     # in pixel size. If the radius is 0, you have no rounded
            #     # corners.
            #     # The radius will be automatically lowered if it exceeds half of the
            #     # notification height to avoid clipping text and/or icons.
            #     corner_radius = 0;

            #     # Ignore the dbus closeNotification message.
            #     # Useful to enforce the timeout set by dunst configuration. Without this
            #     # parameter, an application may close the notification sent before the
            #     # user defined timeout.
            #     ignore_dbusclose = false;

            #     ### Legacy

            #     # Use the Xinerama extension instead of RandR for multi-monitor support.
            #     # This setting is provided for compatibility with older nVidia drivers that
            #     # do not support RandR and using it on systems that support RandR is highly
            #     # discouraged.
            #     #
            #     # By enabling this setting dunst will not be able to detect when a monitor
            #     # is connected or disconnected which might break follow mode if the screen
            #     # layout changes.
            #     force_xinerama = false;

            #     ### mouse

            #     # Defines list of actions for each mouse event
            #     # Possible values are:
            #     # * none: Don't do anything.
            #     # * do_action: If the notification has exactly one action, or one is marked as default,
            #     #              invoke it. If there are multiple and no default, open the context menu.
            #     # * close_current: Close current notification.
            #     # * close_all: Close all notifications.
            #     # These values can be strung together for each mouse event, and
            #     # will be executed in sequence.
            #     mouse_left_click = "close_current";
            #     mouse_middle_click = "do_action, close_current";
            #     mouse_right_click = "close_all";
            #   };

            #   "experimental" = {
            #     # Calculate the dpi to use on a per-monitor basis.
            #     # If this setting is enabled the Xft.dpi value will be ignored and instead
            #     # dunst will attempt to calculate an appropriate dpi value for each monitor
            #     # using the resolution and physical size. This might be useful in setups
            #     # where there are multiple screens with very different dpi values.
            #     per_monitor_dpi = false;
            #   };

            #   shortcuts = {
            #     # Shortcuts are specified as [modifier+][modifier+]...key
            #     # Available modifiers are "ctrl", "mod1" (the alt-key), "mod2",
            #     # "mod3" and "mod4" (windows-key).
            #     # Xev might be helpful to find names for keys.

            #     # Close notification.
            #     close = "ctrl+space";

            #     # Close all notifications.
            #     close_all = "ctrl+shift+space";

            #     # Redisplay last message(s).
            #     # On the US keyboard layout "grave" is normally above TAB and left
            #     # of "1". Make sure this key actually exists on your keyboard layout,
            #     # e.g. check output of 'xmodmap -pke'
            #     history = "ctrl+grave";

            #     # Context menu.
            #     context = "ctrl+shift+period";
            #   };

            #   urgency_low = {
            #     # IMPORTANT: colors have to be defined in quotation marks.
            #     # Otherwise the "#" and following would be interpreted as a comment.
            #     background = "#282a36";
            #     foreground = "#6272a4";
            #     timeout = 10;
            #     # Icon for notifications with low urgency, uncomment to enable
            #     #icon = /path/to/icon
            #   };

            #   urgency_normal = {
            #     background = "#282a36";
            #     foreground = "#bd93f9";
            #     timeout = 10;
            #     # Icon for notifications with normal urgency, uncomment to enable
            #     #icon = /path/to/icon
            #   };

            #   urgency_critical = {
            #     background = "#ff5555";
            #     foreground = "#f8f8f2";
            #     timeout = 0;
            #     # Icon for notifications with critical urgency, uncomment to enable
            #     #icon = /path/to/icon
            #   };
            #   # Every section that isn't one of the above is interpreted as a rules to
            #   # override settings for certain messages.
            #   #
            #   # Messages can be matched by
            #   #    appname (discouraged, see desktop_entry)
            #   #    body
            #   #    category
            #   #    desktop_entry
            #   #    icon
            #   #    match_transient
            #   #    msg_urgency
            #   #    stack_tag
            #   #    summary
            #   #
            #   # and you can override the
            #   #    background
            #   #    foreground
            #   #    format
            #   #    frame_color
            #   #    fullscreen
            #   #    new_icon
            #   #    set_stack_tag
            #   #    set_transient
            #   #    timeout
            #   #    urgency
            #   #
            #   # Shell-like globbing will get expanded.
            #   #
            #   # Instead of the appname filter, it's recommended to use the desktop_entry filter.
            #   # GLib based applications export their desktop-entry name. In comparison to the appname,
            #   # the desktop-entry won't get localized.
            #   #
            #   # SCRIPTING
            #   # You can specify a script that gets run when the rule matches by
            #   # setting the "script" option.
            #   # The script will be called as follows:
            #   #   script appname summary body icon urgency
            #   # where urgency can be "LOW", "NORMAL" or "CRITICAL".
            #   #
            #   # NOTE: if you don't want a notification to be displayed, set the format
            #   # to "".
            #   # NOTE: It might be helpful to run dunst -print in a terminal in order
            #   # to find fitting options for rules.

            #   # Disable the transient hint so that idle_threshold cannot be bypassed from the
            #   # client
            #   #[transient_disable]
            #   #    match_transient = yes
            #   #    set_transient = no
            #   #
            #   # Make the handling of transient notifications more strict by making them not
            #   # be placed in history.
            #   #[transient_history_ignore]
            #   #    match_transient = yes
            #   #    history_ignore = yes

            #   # fullscreen values
            #   # show: show the notifications, regardless if there is a fullscreen window opened
            #   # delay: displays the new notification, if there is no fullscreen window active
            #   #        If the notification is already drawn, it won't get undrawn.
            #   # pushback: same as delay, but when switching into fullscreen, the notification will get
            #   #           withdrawn from screen again and will get delayed like a new notification
            #   #[fullscreen_delay_everything]
            #   #    fullscreen = delay
            #   #[fullscreen_show_critical]
            #   #    msg_urgency = critical
            #   #    fullscreen = show

            #   #[espeak]
            #   #    summary = "*"
            #   #    script = dunst_espeak.sh

            #   #[script-test]
            #   #    summary = "*script*"
            #   #    script = dunst_test.sh

            #   #[ignore]
            #   #    # This notification will not be displayed
            #   #    summary = "foobar"
            #   #    format = ""

            #   #[history-ignore]
            #   #    # This notification will not be saved in history
            #   #    summary = "foobar"
            #   #    history_ignore = yes

            #   #[skip-display]
            #   #    # This notification will not be displayed, but will be included in the history
            #   #    summary = "foobar"
            #   #    skip_display = yes

            #   #[signed_on]
            #   #    appname = Pidgin
            #   #    summary = "*signed on*"
            #   #    urgency = low
            #   #
            #   #[signed_off]
            #   #    appname = Pidgin
            #   #    summary = *signed off*
            #   #    urgency = low
            #   #
            #   #[says]
            #   #    appname = Pidgin
            #   #    summary = *says*
            #   #    urgency = critical
            #   #
            #   #[twitter]
            #   #    appname = Pidgin
            #   #    summary = *twitter.com*
            #   #    urgency = normal
            #   #
            #   #[stack-volumes]
            #   #    appname = "some_volume_notifiers"
            #   #    set_stack_tag = "volume"
            #   #
            # };
        # };
    };
}
