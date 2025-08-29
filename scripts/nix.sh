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
    for i in "$WORK_PATH/files/nix/homes/"*; do
      base_name "$i"
      echo "$RET"
    done
    msg_ask "name (defaut: common): "
    case "$RET" in
      ( "" )
        RET="common"
        ;;
    esac
    msg_log "selected name: $RET"
    nix run home-manager/master -- switch --flake "$WORK_PATH/files/nix#$RET"
  ;;
  ( "rebuild" )
    for i in "$WORK_PATH/files/nix/hosts/"*; do
      base_name "$i"
      echo "$RET"
    done
    msg_ask "name (defaut: laptop): "
    case "$RET" in
      ( "" )
        RET="laptop"
        ;;
    esac
    msg_log "selected name: $RET"
    case "$RET" in
      ( * )
        sudo nixos-rebuild switch --flake "$WORK_PATH/files/nix#$RET" --impure
        ;;
    esac
    ;;
esac
