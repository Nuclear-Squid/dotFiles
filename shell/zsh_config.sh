# My zsh-specific config, mostly weird widgets
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

magic-enter() {
    if [[ -n "$BUFFER" ]]; then
        zle .accept-line
        return
    fi

    echo
    magic_ls
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
