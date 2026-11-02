#!/bin/sh
set -eu


# Runtime implementation stays in this file. Rule scripts use dot() and the
# public helpers below; names beginning with '_' are internal.
# POSIX sh has no local variables: helpers use their own prefix and return
# strings through <function>_RESULT. dot() isolates per-call state in a subshell.

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
    _print_ask_RESULT=""
    read -r _print_ask_RESULT
}

_print_run() {
    printf "%s\n" " ${ESC}[35m[ RUN ]${ESC}[90m: ${ESC}[m$*"
    "$@"
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

# Option specifications are name:0 (flag) or name:1 (value).
# Unknown options are errors, not implicit flags.
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
    _print_error "Unknown option: $_optparser_argc_RESULT"
    return 1
}

# Normalize options before operands; quote every token before the caller's eval.
# Supports --name=value, -d1, mixed clusters such as -rd1, and a literal --.
_optparser() {
    _optparser_RESULT=""
    _optparser__opts=""
    _optparser__opt_args=""
    _optparser__args=""

    while [ $# -gt 0 ]; do
        case "$1" in
            ( "--" )
                shift
                break
                ;;
            ( ?:0 | ?:1 )
                _quote "-$1"
                ;;
            ( ?*:0 | ?*:1 )
                _quote "--$1"
                ;;
            ( * )
                _print_error "Invalid option specification: $1"
                return 1
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
            ( "--"?* )
                _optparser__option="${1%%=*}"
                _optparser_argc "$_optparser__option" "$_optparser__opts" || return 1
                case "$1" in
                    ( "--"?*"="* )
                        if [ "$_optparser_argc_RESULT" -ne 1 ]; then
                            _print_error "Option does not take a value: $_optparser__option"
                            return 1
                        fi
                        _optparser__value="${1#*=}"
                        shift
                        set -- "$_optparser__option" "$_optparser__value" "$@"
                        ;;
                esac
                ;;
            ( '-'?* )
                _optparser__option="${1%"${1#??}"}"
                _optparser_argc "$_optparser__option" "$_optparser__opts" || return 1
                _optparser__rest="${1#??}"
                if [ -n "$_optparser__rest" ]; then
                    shift
                    if [ "$_optparser_argc_RESULT" -eq 1 ]; then
                        set -- "$_optparser__option" "$_optparser__rest" "$@"
                    else
                        set -- "$_optparser__option" "-$_optparser__rest" "$@"
                    fi
                fi
                ;;
            ( * )
                _quote "$1"
                _optparser__args="$_optparser__args $_quote_RESULT"
                shift
                continue
                ;;
        esac

        if [ $# -le "$_optparser_argc_RESULT" ]; then
            _print_error "Missing value for option: $1"
            return 1
        fi
        while [ "$_optparser_argc_RESULT" -ge 0 ]; do
            _quote "$1"
            _optparser__opt_args="$_optparser__opt_args $_quote_RESULT"
            shift
            _optparser_argc_RESULT=$((_optparser_argc_RESULT - 1))
        done
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
    _get_files_recursive__DEPTH="${2:-"-1"}"
    _get_files_recursive__current_depth=0
    set -- "$1"
    while [ $# -gt 0 ]; do
        _get_files_recursive__dir_stack=""
        _get_files_recursive__current_depth=$((_get_files_recursive__current_depth + 1))
        while [ $# -gt 0 ]; do
            for _get_files_recursive__path in "$1"/* "$1"/.[!.]* "$1"/..?*; do
                file_exists "$_get_files_recursive__path" || continue
                _quote "$_get_files_recursive__path"
                # Treat directory symlinks as leaves; following them can loop.
                if [ -d "$_get_files_recursive__path" ] &&
                    [ ! -L "$_get_files_recursive__path" ] &&
                    [ "$_get_files_recursive__current_depth" -ne "$_get_files_recursive__DEPTH" ]; then
                    _get_files_recursive__dir_stack="$_get_files_recursive__dir_stack $_quote_RESULT"
                else
                    _get_files_recursive_RESULT="$_get_files_recursive_RESULT $_quote_RESULT"
                fi
            done
            shift
        done
        eval "set -- $_get_files_recursive__dir_stack"
    done
}

# Public helpers for rule scripts

cmd_exists() {
    command -v -- "$1" > /dev/null 2>&1
}

file_exists() {
    [ -e "$1" ] || [ -L "$1" ]
}

is_deletable() {
    _dirname "$1"
    [ -w "$_dirname_RESULT" ] && [ -x "$_dirname_RESULT" ]
}

is_linked() {
    [ -L "$2" ] || return 1
    # -m also resolves a link whose source has since been removed.
    _is_linked__source="$(realpath -m -- "$1")" || return 1
    _is_linked__target="$(realpath -m -- "$2")" || return 1
    [ "$_is_linked__source" = "$_is_linked__target" ]
}

script_source() {
    # shellcheck disable=SC1090
    . "$SCRIPTS_DIR/$1.sh"
}

script_exists() {
    [ -f "$SCRIPTS_DIR/$1.sh" ]
}


# Sub Commands

_usage() {
    cat <<EOF
Usage: $0 <command> [options...] [scripts...]

Commands:
    help, h          show help
    install, i       install dotfiles
    uninstall, u     remove managed symlinks (keep copied files)
    check, c         check symlink targets or copied-file existence

Options:
    -f, --force              remove conflicting destinations before installing
    -s, --files-path PATH    source root (default: \$FILES_DIR or ./files beside dm)
    -t, --target-path PATH   destination root (default: \$TARGET_DIR or \$HOME)
    --                      treat remaining arguments as script names

Scripts are loaded from \$SCRIPTS_DIR (default: ./scripts beside dm).
common.sh is loaded first when present; the default script is default.sh.

Rule API: dot [options...] SOURCE [TARGET]
    -r, --recursive         visit directory contents, without following symlinks
    -d, --depth N           traversal depth (0 or -1: unlimited, default: -1)
    -f, --force             override the global force setting for this call
    -c, --copy              copy files; directories are skipped
    -t, --template          expand templates when copying
    --files-root PATH      override the source root
    --target-root PATH     override the destination root
    --files-prefix PATH    prepend a source subdirectory
    --target-prefix PATH   prepend a destination subdirectory

Options may follow operands. Short flags may be grouped, e.g. -rct or -rd1.
Failures and check mismatches return a nonzero status. Accepting a conflict
prompt skips that entry; existing copies are skipped unless --force is used.
EOF
}

_run_script() {
    _optparser \
        f:0 force:0 \
        s:1 files-path:1 \
        t:1 target-path:1 \
        -- "$@" || return 1
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
                _print_error "Invalid option: $1"
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

# Template syntax and its AWK interpreter stay together here. A subshell keeps
# the XDG environment imported for expansion out of subsequent rule scripts.
_envsubstcp() (
    if [ -f "$_dot__FILES_DIR/home/config/xdg/user-dirs.dirs" ]; then
        set -a
        # shellcheck disable=SC1091
        . "$_dot__FILES_DIR/home/config/xdg/user-dirs.dirs" || return 1
        set +a
    fi

    awk '
        function expand(remaining,    result, esc_pos, esc_len, tok_pos, tok_len,
                                       token, cmd, varname, value, cmdline) {
            result = ""
            while (length(remaining) > 0) {
                esc_pos = 0
                if (match(remaining, /\\%/)) { esc_pos = RSTART; esc_len = RLENGTH }

                tok_pos = 0
                if (match(remaining, /%!(\\%|[^%])+%|%\$[A-Za-z0-9_]+%/)) {
                    tok_pos = RSTART; tok_len = RLENGTH
                }

                if (esc_pos == 0 && tok_pos == 0) {
                    result = result remaining
                    remaining = ""
                    continue
                }

                if (esc_pos > 0 && (tok_pos == 0 || esc_pos <= tok_pos)) {
                    result = result substr(remaining, 1, esc_pos - 1) "%"
                    remaining = substr(remaining, esc_pos + esc_len)
                    continue
                }

                result = result substr(remaining, 1, tok_pos - 1)
                token = substr(remaining, tok_pos, tok_len)

                if (substr(token, 2, 1) == "!") {
                    cmd = substr(token, 3, length(token) - 3)
                    gsub(/\\%/, "%", cmd)
                    value = ""
                    while ((cmd | getline cmdline) > 0)
                        value = (value == "") ? cmdline : value "\n" cmdline
                    close(cmd)
                } else {
                    varname = substr(token, 3, length(token) - 3)
                    value = ENVIRON[varname]
                }

                result = result value
                remaining = substr(remaining, tok_pos + tok_len)
            }
            return result
        }

        function effectiveActive(   i, a) {
            a = 1
            for (i = 1; i <= depth; i++) a = a && activeArr[i]
            return a
        }

        function parentActiveOfTop(   i, a) {
            a = 1
            for (i = 1; i < depth; i++) a = a && activeArr[i]
            return a
        }

        function classifyLine(trimmed) {
            DIRECTIVE = "text"
            DCMD = ""

            if (trimmed == "%:%") {
                DIRECTIVE = "else"
            } else if (trimmed == "%?%") {
                DIRECTIVE = "endif"
            } else if (trimmed ~ /^%\?(\\%|[^%])*%$/) {
                DCMD = substr(trimmed, 3, length(trimmed) - 3)
                gsub(/\\%/, "%", DCMD)
                DIRECTIVE = "if"
            } else if (trimmed ~ /^%;(\\%|[^%])*%$/) {
                DCMD = substr(trimmed, 3, length(trimmed) - 3)
                gsub(/\\%/, "%", DCMD)
                DIRECTIVE = "elif"
            } else if (trimmed ~ /^%\?/ || trimmed ~ /^%:/ || trimmed ~ /^%;/) {
                DIRECTIVE = "malformed"
            }
        }

        function handleIf(dcmd,    parentActive) {
            parentActive = effectiveActive()
            depth++
            hasElseArr[depth] = 0
            if (parentActive) {
                activeArr[depth] = (system(dcmd) == 0)
                matchedArr[depth] = activeArr[depth]
            } else {
                activeArr[depth] = 0
                matchedArr[depth] = 1
            }
        }

        function handleElif(dcmd,    line) {
            if (depth == 0) {
                warn("%;cmd% without open %?cmd% block, treating as plain text")
                emitIfActive(line)
                return
            }
            if (hasElseArr[depth]) {
                warn("%;cmd% after %:% in same block, treating as plain text")
                emitIfActive(line)
                return
            }
            if (matchedArr[depth]) {
                activeArr[depth] = 0
            } else if (parentActiveOfTop()) {
                activeArr[depth] = (system(dcmd) == 0)
                if (activeArr[depth]) matchedArr[depth] = 1
            } else {
                activeArr[depth] = 0
                matchedArr[depth] = 1
            }
        }

        function handleElse(    line) {
            if (depth == 0) {
                warn("%:% without open %?cmd% block, treating as plain text")
                emitIfActive(line)
                return
            }
            if (hasElseArr[depth]) {
                warn("duplicate %:% in same block, treating as plain text")
                emitIfActive(line)
                return
            }
            hasElseArr[depth] = 1
            if (matchedArr[depth]) {
                activeArr[depth] = 0
            } else {
                activeArr[depth] = 1
                matchedArr[depth] = 1
            }
        }

        function handleEndif(    line) {
            if (depth == 0) {
                warn("%?% without open %?cmd% block, treating as plain text")
                emitIfActive(line)
                return
            }
            delete activeArr[depth]
            delete matchedArr[depth]
            delete hasElseArr[depth]
            depth--
        }

        function warn(msg) {
            print "warning: " msg > "/dev/stderr"
        }

        function emitIfActive(line) {
            if (effectiveActive()) print expand(line)
        }

        BEGIN { depth = 0 }

        {
            trimmed = $0
            sub(/^[ \t]+/, "", trimmed)
            sub(/[ \t]+$/, "", trimmed)

            classifyLine(trimmed)

            if (DIRECTIVE == "if") {
                handleIf(DCMD)
            } else if (DIRECTIVE == "elif") {
                handleElif(DCMD, $0)
            } else if (DIRECTIVE == "else") {
                handleElse($0)
            } else if (DIRECTIVE == "endif") {
                handleEndif($0)
            } else {
                if (DIRECTIVE == "malformed")
                    warn("malformed directive, treating as plain text: " trimmed)
                emitIfActive($0)
            }
        }

        END {
            if (depth > 0)
                warn(depth " unclosed %?cmd% block(s) at end of input (missing %?%)")
        }
    ' "$1" > "$2"
)


# dot

_dot_ask_continue() {
    _print_ask "Continue? [Y/n]: " || return 1
    case "$_print_ask_RESULT" in
        ( [nN] | [nN][oO] ) return 1 ;;
        ( * ) return 0 ;;
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

# Return 0 for a prepared destination or an intentional skip, 1 on failure.
# The caller checks _dot_prepare_target_SKIP before writing anything.
_dot_prepare_target() {
    _dot_prepare_target_SKIP=false
    if file_exists "$2"; then
        if $_dot__FORCE_MODE; then
            if ! is_deletable "$2"; then
                _dot_msg error "$1" "-?-" "$2" "(Not Deletable)"
                return 1
            fi
            if ! _print_run rm -rf -- "$2"; then
                _dot_msg fatal "$1" "-?-" "$2" "(Failed)"
                return 1
            fi
        else
            if $_dot__COPY_MODE; then
                _dot_msg log "$1" "=?=" "$2" "(Already Exist)"
            else
                _dot_msg error "$1" "--x" "$2" "(Already Exist)"
                _dot_ask_continue || return 1
            fi
            _dot_prepare_target_SKIP=true
            return 0
        fi
    fi

    _dirname "$2"
    if ! [ -d "$_dirname_RESULT" ]; then
        if file_exists "$_dirname_RESULT"; then
            _print_error "Cannot make directory: $_dirname_RESULT"
            _dot_ask_continue || return 1
            _dot_prepare_target_SKIP=true
            return 0
        fi
        if ! _print_run mkdir -p -- "$_dirname_RESULT"; then
            _print_fatal "Cannot make directory: $_dirname_RESULT (Failed)"
            return 1
        fi
    fi
    return 0
}

_dot_copy() {
    if $_dot__TEMPLATE_MODE; then
        if ! _envsubstcp "$1" "$2"; then
            _dot_msg fatal "$1" "==x" "$2" "(Failed)"
            return 1
        fi
    elif ! cp -- "$1" "$2"; then
        _dot_msg fatal "$1" "==x" "$2" "(Failed)"
        return 1
    fi
    _dot_msg success "$1" "==>" "$2"
}

_dot_link() {
    if ln -s -- "$1" "$2"; then
        _dot_msg success "$1" "-->" "$2"
    else
        _dot_msg fatal "$1" "--x" "$2" "(Failed)"
        return 1
    fi
}

_dot_install() {
    if $_dot__COPY_MODE; then
        [ ! -d "$1" ] || return 0
    elif is_linked "$1" "$2"; then
        _dot_msg log "$1" "<->" "$2" "(Already Linked)"
        return 0
    fi

    _dot_prepare_target "$@" || return 1
    if $_dot_prepare_target_SKIP; then
        return 0
    fi

    if $_dot__COPY_MODE; then
        _dot_copy "$@"
    else
        _dot_link "$@"
    fi
}

_dot_unlink() {
    if $_dot__COPY_MODE; then
        if file_exists "$2"; then
            _dot_msg log "$1" "=?=" "$2" "(Already Exist)"
        else
            _dot_msg log "$1" "=?=" "$2" "(Not Exist)"
        fi
        return 0
    fi

    if ! is_linked "$1" "$2"; then
        _dot_msg log "$1" "x-x" "$2" "(Already Unlinked)"
        return 0
    fi

    if unlink -- "$2"; then
        _dot_msg success "$1" "x-x" "$2"
        return 0
    else
        _dot_msg fatal "$1" "-?-" "$2" "(Failed)"
        return 1
    fi
}

_dot_check() {
    if $_dot__COPY_MODE; then
        [ ! -d "$1" ] || return 0
        if file_exists "$2"; then
            _dot_msg log "$1" "=?=" "$2" "(Already Exist)"
        else
            _dot_msg warn "$1" "=?=" "$2" "(Not Exist)"
            return 1
        fi
        return 0
    fi

    if [ -e "$2" ] && is_linked "$1" "$2"; then
        _dot_msg success "$1" "<->" "$2"
    else
        _dot_msg warn "$1" "-?-" "$2"
        return 1
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

    # Symlink contents must not depend on the destination's parent directory.
    case "$_dot_decorate_path_RESULT" in
        ( /* ) : ;;
        ( * ) _dot_decorate_path_RESULT="$PWD/$_dot_decorate_path_RESULT" ;;
    esac
}

_dot() {
    case "$SCRIPT_MODE" in
        ( install ) _dot_install "$@" ;;
        ( uninstall ) _dot_unlink "$@" ;;
        ( check ) _dot_check "$@" ;;
        ( * ) _print_error "Invalid script mode: $SCRIPT_MODE"; return 1 ;;
    esac
}

# Per-rule options and helper scratch variables must not leak into callers.
dot() (
    _dot__FILES_DIR="$FILES_DIR"
    _dot__TARGET_DIR="$TARGET_DIR"
    _dot__FORCE_MODE="$FORCE_MODE"
    _dot__FILES_PREFIX=""
    _dot__TARGET_PREFIX=""
    _dot__IS_RECURSIVE=false
    _dot__DEPTH=-1
    _dot__COPY_MODE=false
    _dot__TEMPLATE_MODE=false

    _optparser \
        r:0 recursive:0 \
        f:0 force:0 \
        c:0 copy:0 \
        t:0 template:0 \
        d:1 depth:1 \
        files-root:1 \
        target-root:1 \
        files-prefix:1 \
        target-prefix:1 \
        -- "$@" || return 1
    eval "set -- $_optparser_RESULT"
    while [ $# -gt 0 ]; do
        case "$1" in
            ( -- ) shift ; break ;;
            ( --files-root ) shift ; _dot__FILES_DIR="$1" ; shift 1 ;;
            ( --target-root ) shift ; _dot__TARGET_DIR="$1" ; shift 1 ;;
            ( --files-prefix ) shift ; _dot__FILES_PREFIX="$1" ; shift 1 ;;
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
            ( -c | --copy )
                shift
                _dot__COPY_MODE=true
                ;;
            ( -t | --template )
                shift
                _dot__TEMPLATE_MODE=true
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

    case "$_dot__DEPTH" in
        ( -1 ) : ;;
        ( '' | *[!0-9]* )
            _print_error "Invalid depth: $_dot__DEPTH (expected -1 or a nonnegative integer)"
            return 1
            ;;
    esac
    if ! [ "$_dot__DEPTH" -ge -1 ] 2>/dev/null; then
        _print_error "Depth is out of range: $_dot__DEPTH"
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
                _dot "$1" "$_dot__TARGET/${1#"$_dot__FILE/"}" || return 1
                shift
            done
        else
            _dot "$_dot__FILE" "$_dot__TARGET"
        fi
    elif [ "$SCRIPT_MODE" = uninstall ] && ! $_dot__IS_RECURSIVE; then
        # The exact rule still identifies a managed link after its source is gone.
        _dot "$_dot__FILE" "$_dot__TARGET"
    else
        _print_error "File not found: $_dot__FILE"
        return 1
    fi
)


# Initialization

_initialize() {
    if ! cmd_exists realpath; then
        _print_error "The 'realpath' command is required but not found."
        return 1
    fi

    WORK_PATH="$(realpath -- "$0")" || return 1
    _dirname "$WORK_PATH"
    WORK_DIR="$_dirname_RESULT"
    KERNEL_NAME="$(uname -s)" || return 1
    case "$KERNEL_NAME" in
        ( Linux ) : ;;
        ( * )
            _print_error "\"$KERNEL_NAME\" is not supported."
            return 1
            ;;
    esac

    PARENT_SHELL="${PARENT_SHELL:-"$(ps -o ppid= -p $$ | xargs -I{} ps -o comm= -p {})"}"
    FORCE_MODE=false
    FILES_DIR="${FILES_DIR:-"$WORK_DIR/files"}"
    SCRIPTS_DIR="${SCRIPTS_DIR:-"$WORK_DIR/scripts"}"
    TARGET_DIR="${TARGET_DIR:-"$HOME"}"
}


# Main

main() {
    [ $# -eq 0 ] && set -- help
    case "$1" in
        ( "help" | "h" | "usage" | '-?' | '-h' | '--help' )
            _usage
            return 0
            ;;
        ( "install" | "i" ) SCRIPT_MODE="install" ;;
        ( "uninstall" | "u" ) SCRIPT_MODE="uninstall" ;;
        ( "check" | "c" ) SCRIPT_MODE="check" ;;
        ( * )
            _print_error "Invalid Sub Command: \"$1\""
            _usage
            return 1
            ;;
    esac
    shift
    _initialize || return 1
    _run_script "$@"
}

main "$@"
