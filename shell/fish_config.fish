function fish_greeting
    if test -z "$IN_NIX_SHELL"
        fastfetch
    end
end

alias l         "eza -l"
alias la        "eza -la"
alias rm        "rm -I"
alias cat       "bat"
alias vi        "neovide --fork --"
alias nix-shell "nix-shell --run fish"
alias btm       "btm -r 250ms -g"

abbr -a chux "chmod u+x"
abbr -a lg   "lazygit"
abbr -a v    "nvim"
abbr -a nm   "nmcli"
abbr -a nmc  "nmcli con up"

set -Ux MANPAGER "nvim +Man!"

function nix -a command
    if [ $command = "develop" ]
        command nix develop -c fish $argv[2..]
    else
        command nix $argv
    end
end

function ggez -a commands
    if  [ (string match -e 'u' $commands) ]
        echo ---------------------
        echo \| Updating channels \|
        echo ---------------------
        sudo nix-channel --update
    end

    if  [ (string match -e 's' $commands) ]
        echo --------------------
        echo \| Upgrading system \|
        echo --------------------
        sudo nixos-rebuild switch
    end

    if  [ (string match -e 'h' $commands) ]
        echo ------------------
        echo \| Upgrading home \|
        echo ------------------
        home-manager switch
    end
end

function nix_flake_available
    set dirpath (pwd)
    while test "$dirpath" != "/"
        if test -e "$dirpath/flake.nix"
            return 0
        end
        set dirpath (dirname "$dirpath")
    end
    return 1
end

function get_git_repo_path -a directory
    if test -z "$directory"
        set directory (pwd)
    end
    echo (git -C $directory rev-parse --show-toplevel 2>/dev/null)
end

function git_repo_changed
    set --local prev_git_repo (get_git_repo_path $dirprev[-1])
    set --local curr_git_repo (get_git_repo_path)
    # false
    test -n $curr_git_repo; and test $curr_git_repo != $prev_git_repo
end

function magic_ls
    paste \
        (ll --color=always | psub) \
        (git -c color.ui=always st 2>/dev/null | sed 's/\t/        /g' | psub) \
        | column -s \t -t \
        | sed 's/ *$//'
end

functions --copy cd cd_wrapper
function cf -a directory
    mkdir -p $directory
    cd_wrapper $directory
end

function cd --wraps=cd
    cd_wrapper $argv
    if [ $status -ne 0 ]
        commandline --replace "cd $argv"
        return
    end
    git_repo_changed && onefetch
    magic_ls
end

function cdr -a child_dir
    set --local dir (get_git_repo_path)
    if test -z "$dir"
        set --local dir "$HOME"
    end
    cd "$dir/$child_dir"
end

function cut_last_field -a input delimiter
    echo "$input" | rev | cut -d "$delimiter" -f 1 | rev
end

function gc -a repo
    set --local github_repo_ssh_link $repo
    set --local repo_name (cut_last_field "$github_repo_ssh_link" '/' | cut -d '.' -f 1)
    git clone "$github_repo_ssh_link"
    cd "$repo_name"
end

function duplicate_term; kitty . &; end

function magic_enter
    if test -z (commandline | string join0)
        echo
        magic_ls
        echo -ne '\x1b[A'
    end
    commandline -f execute
end

bind \e\x7F yazi
bind \e\x20 duplicate_term
bind \cM magic_enter

function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item
