alias l="eza -l"
alias la="eza -la"
alias cat="bat"
alias chux="chmod u+x"
alias ggez="sudo nixos-rebuild switch --show-trace"

default_ls_command() {
    eza -l --git-ignore
}

magic-enter() {
    if [ -z $BUFFER ]; then
        echo
        default_ls_command
        echo -ne "\x1b[A"
    fi
    zle accept-line
}

zle -N magic-enter
bindkey "^M" magic-enter


cf() { mkdir -p $1 && builtin cd $1 }

# cd, but better (what exactly do you mean by "just use `ls` you lazy fuck"?)
cd() {
    local previous_git_repo="$(git rev-parse --show-toplevel 2>/dev/null)"
    local auto_jumped_path=""
    builtin cd "${1:-$HOME}" || return
    # Only one thing in current dir and it’s another dir
    while [ "$(find ./ -mindepth 1 -maxdepth 1 | wc -l)" = 1 ] &&
          [ "$(find ./ -mindepth 1 -maxdepth 1 -type d | wc -l)" = 1 ]
    do
        next_dir=$(ls -A)
        auto_jumped_path="$auto_jumped_path$next_dir/"
        builtin cd "$next_dir" || return
    done
    local current_git_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
    [ "$current_git_dir" != "" ] && [ "$current_git_dir" != "$previous_git_repo" ] && onefetch
    default_ls_command
    if [ $auto_jumped_path ]; then
        echo -e "\x1b[1;35mAuto-jumped\x1b[0m inside of \x1b[3;33m$auto_jumped_path\x1b[0m"
    fi
}
