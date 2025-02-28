
cut_last_field() { echo "$1" | rev | cut -d "$2" -f 1 | rev }

get_git_repo_path() {
    echo "$(git rev-parse --show-toplevel 2>/dev/null)"
}

git_repo_changed() {
    local prev_git_repo=$(builtin cd $OLDPWD; get_git_repo_path)
    local curr_git_repo=$(get_git_repo_path)
    [[ "$curr_git_repo" != "" && "$curr_git_repo" != "$prev_git_repo" ]]
    return $?
}

default_ls_command() {
    eza -l --git-ignore $eza_extra_options $@
}

magic_ls() {
    paste \
        <(default_ls_command --color=always) \
        <(git -c color.ui=always st 2>/dev/null | sed 's/\t/        /g') \
        | column -s $'\t' -t \
        | sed 's/ *$//'
}
