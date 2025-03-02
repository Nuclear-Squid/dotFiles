# My shell aliases and commands, that can be used in pretty much any of shell

alias l="eza -l"
alias la="eza -la"
alias rm="rm -I"
alias cat="bat"
alias chux="chmod u+x"
alias ggez="sudo nixos-rebuild switch --show-trace"
alias vi="neovide --fork --"
alias v="nvim"
alias lg="lazygit"

cf() { mkdir -p $1 && builtin cd $1 }

# cd, but better (what exactly do you mean by "just use `ls` you lazy fuck"?)
cd() {
    builtin cd "${1:-$HOME}" || return
    # Only one thing in current dir and it’s another dir
    while [ "$(find ./ -mindepth 1 -maxdepth 1 | wc -l)" = 1 ] &&
          [ "$(find ./ -mindepth 1 -maxdepth 1 -type d | wc -l)" = 1 ]
    do
        next_dir=$(ls -A)
        auto_jumped_path="$auto_jumped_path$next_dir/"
        builtin cd "$next_dir" || return
    done

    git_repo_changed && onefetch
    magic_ls

    if [ $auto_jumped_path ]; then
        echo -e "\x1b[1;35mAuto-jumped\x1b[0m inside of \x1b[3;33m$auto_jumped_path\x1b[0m"
    fi
}

gc() {
    local github_repo_ssh_link="$1"
    local repo_name=$(cut_last_field "$github_repo_ssh_link" '/' | cut -d '.' -f 1)
    git clone "$github_repo_ssh_link"
    cd "$repo_name"
}

t() {
    __zoxide_z "$@"
    git_repo_changed && onefetch
    magic_ls
}

ti() {
    __zoxide_zi "$@"
    git_repo_changed && onefetch
    magic_ls
}
