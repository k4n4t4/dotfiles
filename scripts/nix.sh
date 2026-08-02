_print_log "1. home-manager"
_print_log "2. rebuild"

_print_ask "mode (defaut: home-manager): "

# shellcheck disable=SC2154
case "$_print_ask_RESULT" in
    ( 1 | "home-manager" )
        RET="home-manager"
        ;;
    ( 2 | "rebuild" )
        RET="rebuild"
        ;;
    ( * )
        RET="home-manager"
        ;;
esac

_print_log "selected mode: $RET"

case "$RET" in
    ( "home-manager" )
        _print_log "available configurations:"
        _print_log "  - common"
        _print_log "  - desktop"
        _print_ask "name (defaut: common): "
        case "$_print_ask_RESULT" in ( "" )
            RET="common"
        esac
        _print_log "selected name: $RET"
        _print_run nix run --extra-experimental-features "nix-command flakes" home-manager/master -- switch --flake "$DOTFILES_PATH/nix#$RET" --impure
        ;;
    ( "rebuild" )
        _print_log "available configurations:"
        _print_log "  - desktop"
        _print_log "  - laptop"
        _print_log "  - wsl"
        _print_ask "name (defaut: desktop): "
        case "$_print_ask_RESULT" in ( "" )
            RET="desktop"
        esac
        _print_log "selected name: $RET"
        _print_run sudo nixos-rebuild switch --flake "$DOTFILES_PATH/nix#$RET" --impure
        ;;
esac
