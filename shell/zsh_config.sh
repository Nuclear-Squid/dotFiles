# My zsh-specific config, mostly weird widgets

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

default_ls_command() {
    eza -l --git-ignore $eza_extra_options $@
}

get_git_repo_path() {
    echo "$(git rev-parse --show-toplevel 2>/dev/null)"
}

magic-enter() {
    if [[ -n "$BUFFER" ]]; then
        zle .accept-line
        return
    fi

    echo
    paste \
        <(default_ls_command --color=always) \
        <(git -c color.ui=always st 2>/dev/null | sed 's/\t/        /g') \
        | column -s $'\t' -t \
        | sed 's/ *$//'
    echo -ne "\x1b[A"

    zle .accept-line
}

zle -N magic-enter
bindkey '^M' magic-enter


run_yazi() { yazi }
zle -N run_yazi
bindkey '\e^?' run_yazi


duplicate_terminal() { kitty . & }
zle -N duplicate_terminal
bindkey '^[ ' duplicate_terminal
