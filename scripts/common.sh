alias dothome="dot --origin-prefix=home"
alias dotconf="dot --origin-prefix=home/.config --target-prefix=.config"
script_source() {
    # shellcheck disable=SC1090
    . "$SCRIPTS_PATH/${1}.sh"
}
