#!/bin/sh
set -eu


# Constants

ESC="$(printf "\033")"


# Utils

_print_log() {
    printf "%s\n" " ${ESC}[32m[ LOG ]${ESC}[90m: ${ESC}[m$*"
}

_print_success() {
    printf "%s\n" " ${ESC}[92m[ SUC ]${ESC}[90m: ${ESC}[m$*"
}

_print_info() {
    printf "%s\n" " ${ESC}[94m[ INF ]${ESC}[90m: ${ESC}[m$*"
}

_print_debug() {
    printf "%s\n" " ${ESC}[97m${ESC}[43m[ DBG ]${ESC}[m${ESC}[90m: ${ESC}[m$*"
}

_print_warn() {
    printf "%s\n" " ${ESC}[93m[ WRN ]${ESC}[90m: ${ESC}[m$*" >&2
}

_print_error() {
    printf "%s\n" " ${ESC}[91m[ ERR ]${ESC}[90m: ${ESC}[m$*" >&2
}

_print_fatal() {
    printf "%s\n" " ${ESC}[97m${ESC}[41m[ FTL ]${ESC}[m${ESC}[90m: ${ESC}[m$*" >&2
}

_print_ask() {
    printf "%s" " ${ESC}[33m[ ASK ]${ESC}[90m: ${ESC}[m$*"
    read -r _print_ask_RESULT
}

_print_run() {
    printf "%s\n" " ${ESC}[35m[ RUN ]${ESC}[90m: ${ESC}[m$*"
    "$@"
    return $?
}

_dirname() {
    if [ $# -eq 0 ]; then
        _print_error "No arguments provided to _dirname."
        return 1
    fi

    if [ -z "$1" ]; then
        _dirname_RESULT="."
        return 0
    fi

    set -- "${1%"${1##*[!/]}"}"

    case "$1" in
        ( "" )
            set -- "/"
            ;;
        ( */* )
            set -- "${1%/*}"
            set -- "${1%"${1##*[!/]}"}"
            if [ -z "$1" ]; then
                set -- "/"
            fi
            ;;
        ( * )
            set -- "."
            ;;
    esac

    _dirname_RESULT="$1"
}

_basename() {
    if [ $# -eq 0 ]; then
        _print_error "No arguments provided to _basename."
        return 1
    fi

    if [ -z "$1" ]; then
        _basename_RESULT=""
        return 0
    fi

    set -- "${1%"${1##*[!/]}"}"

    case "$1" in
        ( "" )
            set -- "/"
            ;;
        ( */* )
            set -- "${1##*/}"
            ;;
    esac

    _basename_RESULT="$1"
}

_quote() {
    if [ $# -eq 0 ]; then
        _print_error "No arguments provided to _quote."
        return 1
    fi

    _quote_RESULT="$1"
    set -- ""
    while : ; do
        case "$_quote_RESULT" in
            ( *"'"* )
                set -- "$1${_quote_RESULT%%"'"*}'\\''"
                _quote_RESULT="${_quote_RESULT#*"'"}"
                ;;
            ( * )
                _quote_RESULT="'$1$_quote_RESULT'"
                break
                ;;
        esac
    done
}

_optparser_argc() {
    _optparser_argc_RESULT="$1"
    eval "set -- $2"
    while [ $# -gt 0 ]; do
        case "$1" in
            ( "$_optparser_argc_RESULT:"?* )
                _optparser_argc_RESULT="${1#"$_optparser_argc_RESULT:"}"
                return 0
                ;;
        esac
        shift
    done
    _optparser_argc_RESULT=0
    return 0
}

_optparser() {
    _optparser__opts=""
    _optparser__opt_args=""
    _optparser__args=""

    while [ $# -gt 0 ]; do
        case "$1" in
            ( "--" )
                shift
                break
                ;;
            ( ?":"?* )
                _quote "-$1"
                ;;
            ( ?*":"?* )
                _quote "--$1"
                ;;
            ( ? )
                _quote "-$1:1"
                ;;
            ( ?* )
                _quote "--$1:1"
                ;;
            ( * )
                shift
                continue
                ;;
        esac
        _optparser__opts="$_optparser__opts $_quote_RESULT"
        shift
    done

    while [ $# -gt 0 ]; do
        case "$1" in
            ( "--" )
                shift
                break
                ;;
            ( "--"?* | "-"? )
                case "$1" in
                    ( "--"?*"="* )
                        _optparser_RESULT="$1"
                        shift
                        set -- "${_optparser_RESULT%%"="*}" "${_optparser_RESULT#*"="}" "$@"
                        continue
                        ;;
                esac
                _optparser_argc "$1" "$_optparser__opts"
                if [ $# -gt "$_optparser_argc_RESULT" ]; then
                    while [ "$_optparser_argc_RESULT" -ge 0 ]; do
                        _quote "$1"
                        _optparser__opt_args="$_optparser__opt_args $_quote_RESULT"
                        shift
                        _optparser_argc_RESULT=$((_optparser_argc_RESULT - 1))
                    done
                else
                    shift
                fi
                ;;
            ( '-'?* )
                _optparser_argc "${1%"${1#??}"}" "$_optparser__opts"
                if [ "$_optparser_argc_RESULT" -eq 1 ]; then
                    _optparser_RESULT="$1"
                    shift
                    set -- "${_optparser_RESULT%"${_optparser_RESULT#??}"}" "${_optparser_RESULT#??}" "$@"
                    continue
                fi

                _optparser__short_opts="${1#'-'}"
                while [ -n "$_optparser__short_opts" ]; do
                    _optparser_short_opt="-${_optparser__short_opts%"${_optparser__short_opts#?}"}"
                    _optparser_argc "$_optparser_short_opt" "$_optparser__opts"
                    if [ "$_optparser_argc_RESULT" -eq 0 ] && [ "$_optparser_short_opt" != '--' ]; then
                        _quote "$_optparser_short_opt"
                        _optparser__opt_args="$_optparser__opt_args $_quote_RESULT"
                    fi
                    _optparser__short_opts="${_optparser__short_opts#?}"
                done
                shift
                ;;
            ( * )
                _quote "$1"
                _optparser__args="$_optparser__args $_quote_RESULT"
                shift
                ;;
        esac
    done

    while [ $# -gt 0 ]; do
        _quote "$1"
        _optparser__args="$_optparser__args $_quote_RESULT"
        shift
    done

    _optparser_RESULT="${_optparser__opt_args#' '} -- ${_optparser__args#' '}"
}

_get_files_recursive() {
    _get_files_recursive_RESULT=""
    _get_files_recursive__DEPTH="${2:-1000}"
    _get_files_recursive__current_depth=0
    set -- "$1"
    while [ $# -gt 0 ]; do
        _get_files_recursive__dir_stack=""
        _get_files_recursive__current_depth=$((_get_files_recursive__current_depth + 1))
        while [ $# -gt 0 ]; do
            for i in "$1"/* "$1"/.*; do
                _basename "$i"
                case "$_basename_RESULT" in ( '.' | '..' | '*' | '.*' ) continue ;; esac
                if [ -d "$i" ] && [ "$_get_files_recursive__current_depth" -ne "$_get_files_recursive__DEPTH" ]; then
                    _quote "$i"
                    _get_files_recursive__dir_stack="$_get_files_recursive__dir_stack $_quote_RESULT"
                else
                    _quote "$i"
                    _get_files_recursive_RESULT="$_get_files_recursive_RESULT $_quote_RESULT"
                fi
            done
            shift
        done
        eval 'set -- "$@" '"$_get_files_recursive__dir_stack"
    done
}

true() {
    return 0
}

false() {
    return 1
}

cmd_exists() {
    command -v -- "$1" > /dev/null 2>&1
}

file_exists() {
    if [ -e "$1" ] || [ -L "$1" ]; then
        return 0
    else
        return 1
    fi
}

is_deletable() {
    _dirname "$1"
    if [ -w "$_dirname_RESULT" ] && [ -x "$_dirname_RESULT" ]; then
        return 0
    else
        return 1
    fi
}

is_linked() {
    if [ -L "$2" ] && [ "$1" = "$(realpath "$2")" ]; then
        return 0
    else
        return 1
    fi
}

script_source() {
    # shellcheck disable=SC1090
    . "$SCRIPTS_DIR/$1.sh"
}

script_exists() {
    if [ -f "$SCRIPTS_DIR/$1.sh" ]; then
        return 0
    else
        return 1
    fi
}


# Sub Commands

_usage() {
    echo "Usage"
    echo "    $0 <SUB_COMMANDS> [options...]"
    echo
    echo "Sub Commands"
    echo "    help             show help"
    echo "    install          install dotfiles"
    echo "    uninstall        uninstall dotfiles"
    echo "    check            check dotfiles"
}

_run_script() {
    case "$SCRIPT_MODE" in
        ( "install" )
            _dot() {
                _dot_link "$@"
            }
            ;;
        ( "uninstall" )
            _dot() {
                _dot_unlink "$@"
            }
            ;;
        ( "check" )
            _dot() {
                _dot_check "$@"
            }
            ;;
    esac

    _optparser \
        t:1 target-path:1 \
        -- "$@"
    eval "set -- $_optparser_RESULT"
    while [ $# -gt 0 ]; do
        case "$1" in
            ( -- )
                shift
                break
                ;;
            ( -f | --force )
                shift
                FORCE_MODE=true
                ;;
            ( -s | --files-path )
                shift
                FILES_DIR="$1"
                shift 1
                ;;
            ( -t | --target-path )
                shift
                TARGET_DIR="$1"
                shift 1
                ;;
            ( * )
                _print_error "Invalid Option."
                return 1
                ;;
        esac
    done

    [ $# -eq 0 ] && set -- "default"

    if script_exists "common"; then
        script_source "common"
    fi

    while [ $# -gt 0 ]; do
        if script_exists "$1"; then
            script_source "$1"
        else
            _print_error "\"$1\" is not found."
            return 1
        fi

        shift
    done
}


# dot

_dot_ask_continue() {
    _print_ask "Continue? [Y/n]: "
    case "$_print_ask_RESULT" in
        ( [nN] )
            RET=1
            ;;
        ( * )
            RET=0
            ;;
    esac
}

_dot_msg() {
    set -- "$1" "$2" "$3" "$4" "${5:-}"

    case "$2" in
        ( "$FILES_DIR/"* )
            set -- "$1" "\$FILES_DIR${2#"$FILES_DIR"}" "$3" "$4" "$5"
            ;;
        ( "$WORK_DIR/"* )
            set -- "$1" "\$WORK_DIR${2#"$WORK_DIR"}" "$3" "$4" "$5"
            ;;
    esac
    case "$4" in
        ( "$HOME/"* )
            set -- "$1" "$2" "$3" "~${4#"$HOME"}" "$5"
            ;;
    esac
    if [ "$5" = "" ]; then
        "_print_$1" "$2 ${ESC}[90m$3${ESC}[m $4"
    else
        "_print_$1" "$2 ${ESC}[90m$3${ESC}[m $4 ${ESC}[90m$5${ESC}[m"
    fi
}

_dot_link() {
    if file_exists "$2"; then
        if is_linked "$1" "$2"; then
            _dot_msg log "$1" "<->" "$2" "(Already Linked)"
            return 0
        fi
        if ! $_dot__FORCE_MODE; then
            _dot_msg error "$1" "--x" "$2" "(Already Exist)"
            _dot_ask_continue
            return "$RET"
        fi
        if ! is_deletable "$2"; then
            _dot_msg error "$1" "-?-" "$2" "(Not Deletable)"
            _dot_ask_continue
            return "$RET"
        fi
        if ! _print_run rm -rf -- "$2"; then
            _dot_msg fatal "$1" "-?-" "$2" "(Faild)"
            return 1
        fi
    fi

    _dirname "$2"
    TMP="$_dirname_RESULT"
    if ! [ -d "$TMP" ]; then
        if file_exists "$TMP"; then
            _print_error "Cannot make directory: $TMP"
            _dot_ask_continue
            return "$RET"
        fi
        if ! _print_run mkdir -p -- "$TMP"; then
            _print_fatal "Cannot make directory: $TMP (Faild)"
            return 1
        fi
    fi

    if ! ln -s -- "$1" "$2"; then
        _dot_msg fatal "$1" "--x" "$2" "(Faild)"
        return 1
    fi

    _dot_msg success "$1" "-->" "$2"
}

_dot_unlink() {
    if is_linked "$1" "$2"; then
        if unlink -- "$2"; then
            _dot_msg success "$1" "x-x" "$2"
        else
            _dot_msg fatal "$1" "-?-" "$2" "(Faild)"
            return 1
        fi
    else
        _dot_msg log "$1" "x-x" "$2" "(Already Unlinked)"
    fi
}

_dot_check() {
    if is_linked "$1" "$2"; then
        _dot_msg success "$1" "<->" "$2"
    else
        _dot_msg warn "$1" "-?-" "$2"
    fi
}

_dot_decorate_path() {
    _dot_decorate_path_RESULT="$1"
    case "$1" in
        ( "/"* )
            :
            ;;
        ( * )
            shift
            while [ $# -gt 0 ]; do
                if [ -n "$1" ]; then
                    _dot_decorate_path_RESULT="$1/$_dot_decorate_path_RESULT"
                fi
                shift
            done
            ;;
    esac
}

_dot() {
    :
}

dot() {
    _dot__FILES_DIR="$FILES_DIR"
    _dot__TARGET_DIR="$TARGET_DIR"
    _dot__FORCE_MODE="$FORCE_MODE"
    _dot__FILES_PREFIX=""
    _dot__TARGET_PREFIX=""
    _dot__FILE=""
    _dot__TARGET=""
    _dot__IS_RECURSIVE=false
    _dot__DEPTH=-1

    _optparser \
        d:1 depth:1 \
        origin-root:1 \
        target-root:1 \
        origin-prefix:1 \
        target-prefix:1 \
        -- "$@"
    eval "set -- $_optparser_RESULT"
    while [ $# -gt 0 ]; do
        case "$1" in
            ( -- ) shift ; break ;;
            ( --origin-root ) shift ; _dot__FILES_DIR="$1" ; shift 1 ;;
            ( --target-root ) shift ; _dot__TARGET_DIR="$1" ; shift 1 ;;
            ( --origin-prefix ) shift ; _dot__FILES_PREFIX="$1" ; shift 1 ;;
            ( --target-prefix ) shift ; _dot__TARGET_PREFIX="$1" ; shift 1 ;;
            ( -r | --recursive )
                shift
                _dot__IS_RECURSIVE=true
                ;;
            ( -f | --force )
                shift
                _dot__FORCE_MODE=true
                ;;
            ( -d | --depth )
                shift
                _dot__DEPTH="$1"
                shift 1
                ;;
            ( * )
                _print_error "Invalid Option: $1"
                return 1
                ;;
        esac
    done

    if [ $# -eq 0 ] || [ $# -gt 2 ]; then
        _print_error "Wrong number of arguments."
        return 1
    fi

    _dot__FILE="$1"
    _dot__TARGET="${2:-"$1"}"
    _dot_decorate_path "$_dot__FILE" "$_dot__FILES_PREFIX" "$_dot__FILES_DIR"
    _dot__FILE="$_dot_decorate_path_RESULT"
    _dot_decorate_path "$_dot__TARGET" "$_dot__TARGET_PREFIX" "$_dot__TARGET_DIR"
    _dot__TARGET="$_dot_decorate_path_RESULT"


    if [ -e "$_dot__FILE" ]; then
        if $_dot__IS_RECURSIVE && [ -d "$_dot__FILE" ]; then
            _get_files_recursive "$_dot__FILE" "$_dot__DEPTH"
            eval "set -- $_get_files_recursive_RESULT"
            while [ $# -gt 0 ]; do
                _dot "$1" "$_dot__TARGET/${1#"$_dot__FILE/"}"
                shift
            done
        else
            _dot "$_dot__FILE" "$_dot__TARGET"
        fi
    else
        _print_error "File not found: $_dot__FILE"
    fi
}


# Initialization

if ! cmd_exists realpath; then
    _print_error "The 'realpath' command is required but not found."
    return 1
fi

WORK_PATH="$(realpath "$0")"
_dirname "$WORK_PATH"
WORK_DIR="$_dirname_RESULT"
KERNEL_NAME="$(uname -s)"
PARENT_SHELL="${PARENT_SHELL:-"$(ps -o ppid= -p $$ | xargs -I{} ps -o comm= -p {})"}"

FORCE_MODE=false
FILES_DIR="${FILES_DIR:-"$WORK_DIR/files"}"
SCRIPTS_DIR="${SCRIPTS_DIR:-"$WORK_DIR/scripts"}"
TARGET_DIR="${TARGET_DIR:-"$HOME"}"

case "$KERNEL_NAME" in
    ( Linux ) : ;;
    ( * )
        _print_error "\"$KERNEL_NAME\" is not supported."
        return 1
        ;;
esac


# Main

main() {
    [ $# -eq 0 ] && set -- help
    case "$1" in
        ( "help" | "h" | "usage" | '-?' | '-h' | '--help' )
            shift
            _usage
            ;;
        ( "install" | "i" )
            shift
            SCRIPT_MODE="install"
            _run_script "$@"
            ;;
        ( "uninstall" | "u" )
            shift
            SCRIPT_MODE="uninstall"
            _run_script "$@"
            ;;
        ( "check" | "c" )
            shift
            SCRIPT_MODE="check"
            _run_script "$@"
            ;;
        ( * )
            _print_error "Invalid Sub Command: \"$1\""
            shift
            _usage
            return 1
            ;;
    esac
}

main "$@"
