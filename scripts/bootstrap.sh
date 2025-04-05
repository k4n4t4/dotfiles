SHELL_PATH="$(realpath "/proc/$$/exe")"
SHELL_NAME="${SHELL_PATH##*"/"}"
case "$SHELL_NAME" in
  ( bash )
    # shellcheck disable=SC3044
    shopt -s expand_aliases
    ;;
  ( zsh )
    emulate -R sh
    ;;
  ( yash | dash | ksh93 | busybox ) : ;;
  ( * )
    echo "\"$SHELL_PATH\" is not supported." >&2
    exit 1
    ;;
esac

KERNEL_NAME="$(uname -s)"
case "$KERNEL_NAME" in
  ( Linux* ) : ;;
  ( * )
    echo "\"$KERNEL_NAME\" is not supported." >&2
    exit 1
    ;;
esac

PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/go/bin:$PATH"
PATH="/snap/bin:$PATH"
PATH="/usr/sandbox:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/share/games:$PATH"
PATH="/usr/sbin:$PATH"
PATH="/sbin:$PATH"
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"

dot_mode="unknown"
dot_opts=""
. "$WORK_PATH/scripts/dot.sh"

. "$WORK_PATH/scripts/libs/utils.sh"
. "$WORK_PATH/scripts/libs/print.sh"
. "$WORK_PATH/scripts/libs/func.sh"

. "$WORK_PATH/scripts/commands/usage.sh"
. "$WORK_PATH/scripts/commands/debug.sh"
. "$WORK_PATH/scripts/commands/install.sh"
. "$WORK_PATH/scripts/commands/uninstall.sh"
. "$WORK_PATH/scripts/commands/check.sh"


if [ -f "$WORK_PATH/config.sh" ]; then
  . "$WORK_PATH/config.sh"
fi


if ${CHECK_INSTALL_LOCATION:-false} &&
  [ "$WORK_PATH" != "$HOME/dotfiles" ]; then
  warn "Installed location is not \"~/dotfiles\""
  info "Installed on \"$WORK_PATH\""
  ask "Continue? [y/N]: "
  case "$RET" in
    ( [Yy] ) : ;;
    ( * )
      log "Canceled."
      return 0
      ;;
  esac
fi
