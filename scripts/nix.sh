msg_log "1. home-manager"
msg_log "2. rebuild"

msg_ask "mode (defaut: home-manager): "

case "$RET" in
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

msg_log "selected mode: $RET"

case "$RET" in
  ( "home-manager" )
    msg_log "available configurations:"
    msg_log "  - common"
    msg_log "  - desktop"
    msg_ask "name (defaut: common): "
    case "$RET" in ( "" )
      RET="common"
    esac
    msg_log "selected name: $RET"
    msg_run nix run --extra-experimental-features nix-command home-manager/master -- switch --flake "$WORK_PATH/files/nix#$RET" --impure
  ;;
  ( "rebuild" )
    msg_log "available configurations:"
    msg_log "  - desktop"
    msg_log "  - laptop"
    msg_log "  - wsl"
    msg_ask "name (defaut: desktop): "
    case "$RET" in ( "" )
      RET="desktop"
    esac
    msg_log "selected name: $RET"
    msg_run sudo nixos-rebuild switch --flake "$WORK_PATH/files/nix#$RET" --impure
    ;;
esac
