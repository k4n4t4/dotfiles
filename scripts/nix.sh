msg_log " 1. home-manager"
msg_log " 2. rebuild"

printf %s " mode (defaut: home-manager): "
read -r mode

case "$mode" in
  ( 1 | "home-manager" )
    mode="home-manager"
    ;;
  ( 2 | "rebuild" )
    mode="rebuild"
    ;;
  ( * )
    mode="home-manager"
    ;;
esac

case "$mode" in
  ( "home-manager" )
    printf %s " name (defaut: common): "
    read -r name
    case "$name" in ( "" )
      name="common"
    esac
    nix run home-manager/master -- switch --flake "$WORK_PATH/files/nix"#"$name"
  ;;
  ( "rebuild" )
    printf %s " name (defaut: nixos): "
    read -r name
    case "$name" in ( "" )
      name="nixos"
    esac
    sudo nixos-rebuild switch --flake "$WORK_PATH/files/nix"#"$name"
    ;;
esac
