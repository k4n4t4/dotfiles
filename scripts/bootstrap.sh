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

. "$WORK_PATH/config.sh"

dot_mode="unknown"
dot_opts=""
. "$WORK_PATH/scripts/dot.sh"

. "$WORK_PATH/scripts/libs/utils.sh"
. "$WORK_PATH/scripts/libs/print.sh"
. "$WORK_PATH/scripts/libs/func.sh"

. "$WORK_PATH/scripts/commands/usage.sh"
. "$WORK_PATH/scripts/commands/status.sh"
. "$WORK_PATH/scripts/commands/install.sh"
. "$WORK_PATH/scripts/commands/uninstall.sh"
. "$WORK_PATH/scripts/commands/check.sh"
