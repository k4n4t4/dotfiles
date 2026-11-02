#!/bin/sh
# Black-box regression tests. Usage: DM_SHELL=dash sh tests/dm.sh
# For bash: POSIXLY_CORRECT=1 DM_SHELL=bash sh tests/dm.sh
# No real dotfiles or setup scripts are installed.
set -eu

DM="$(cd "$(dirname "$0")/.." && pwd)/dm"
DM_SHELL="${DM_SHELL:-sh}"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf -- "$TEST_ROOT"' 0
trap 'exit 1' HUP INT TERM
case_number=0

new_case() {
    case_number=$((case_number + 1))
    case_name="$1"
    case_root="$TEST_ROOT/$case_number"
    mkdir -p "$case_root/files" "$case_root/target" "$case_root/scripts"
    : > "$case_root/input"
}

run_dm() (
    cd "$case_root"
    FILES_DIR="$case_root/files" TARGET_DIR="$case_root/target" \
        SCRIPTS_DIR="$case_root/scripts" PARENT_SHELL=test \
        timeout 10 "$DM_SHELL" "$DM" "$@"
)

fail() {
    printf 'not ok %s - %s: %s\n' "$case_number" "$case_name" "$*" >&2
    if [ -f "$case_root/output" ]; then cat "$case_root/output" >&2; fi
    exit 1
}

expect_success() {
    if ! run_dm "$@" < "$case_root/input" > "$case_root/output" 2>&1; then
        fail "expected success: $*"
    fi
}

expect_failure() {
    if run_dm "$@" < "$case_root/input" > "$case_root/output" 2>&1; then
        fail "expected failure: $*"
    else
        result=$?
        [ "$result" -ne 124 ] || fail "command timed out: $*"
    fi
}

assert() {
    if ! "$@"; then fail "assertion failed: $*"; fi
}

pass() {
    printf 'ok %s - %s\n' "$case_number" "$case_name"
}

new_case 'help and invalid commands'
expect_success help
assert grep -q -- '--files-path' "$case_root/output"
expect_success
expect_failure unknown-command
pass

new_case 'source/target options, aliases, idempotency and removal'
printf 'content\n' > "$case_root/files/item"
printf 'dot item nested/item\n' > "$case_root/scripts/default.sh"
expect_success i --files-path "$case_root/files" --target-path "$case_root/target"
assert test -L "$case_root/target/nested/item"
expect_success install -s"$case_root/files" -t"$case_root/target"
expect_success c --files-path="$case_root/files" --target-path="$case_root/target"
expect_success u
assert test ! -L "$case_root/target/nested/item"
expect_success uninstall
pass

new_case 'CLI validation occurs before any script is sourced'
printf 'touch "$TARGET_DIR/ran"\n' > "$case_root/scripts/common.sh"
printf ':\n' > "$case_root/scripts/default.sh"
for option in -s --files-path -t --target-path --unknown -fz --force=yes; do
    expect_failure install "$option"
    assert test ! -e "$case_root/target/ran"
done
expect_failure install --files-path
assert grep -q 'Missing value for option: --files-path' "$case_root/output"
expect_failure install absent-script
pass

new_case 'dot rejects unknown options, missing values and invalid depths'
printf 'data\n' > "$case_root/files/item"
for arguments in 'item --unknown' 'item -rz' 'item -d' 'item --depth' \
    'item --files-root' 'item --target-root' 'item --files-prefix' \
    'item --target-prefix' 'item --copy=yes' 'item -dno' 'item -d-2' \
    'item -d999999999999999999999999999' '' 'item a b'; do
    printf 'dot %s\n' "$arguments" > "$case_root/scripts/default.sh"
    expect_failure install
    assert test ! -e "$case_root/target/item"
done
printf 'dot item -d\n' > "$case_root/scripts/default.sh"
expect_failure install
assert grep -q 'Missing value for option: -d' "$case_root/output"
pass

new_case 'options after operands and mixed short clusters'
mkdir -p "$case_root/files/tree/nested"
printf 'data\n' > "$case_root/files/tree/nested/item"
printf 'dot tree installed -rd1\n' > "$case_root/scripts/default.sh"
expect_success install
assert test -L "$case_root/target/installed/nested"
expect_success check
expect_success uninstall
printf 'dot tree installed -r -d 0\n' > "$case_root/scripts/default.sh"
expect_success install
assert test ! -L "$case_root/target/installed/nested"
assert test -L "$case_root/target/installed/nested/item"
pass

new_case 'literal operands after -- and relative roots'
printf 'data\n' > "$case_root/files/-item"
printf 'dot -- -item\n' > "$case_root/scripts/-rules.sh"
expect_success install -s files -t target -- -rules
assert cmp "$case_root/files/-item" "$case_root/target/-item"
expect_success check -s files -t target -- -rules
expect_success uninstall -s files -t target -- -rules
assert test ! -L "$case_root/target/-item"
pass

new_case 'recursive filenames survive quoting and are never evaluated'
for name in 'space name' "quote'name" '*' '.*' '.hidden' '..hidden' \
    '$(touch injected)' '`touch injected`' 'back\slash' 'line
break'; do
    printf '%s\n' "$name" > "$case_root/files/$name"
done
printf 'dot . output -r\n' > "$case_root/scripts/default.sh"
expect_success install
for path in "$case_root/files"/* "$case_root/files"/.[!.]* "$case_root/files"/..?*; do
    assert test -L "$case_root/target/output/${path##*/}"
    assert cmp "$path" "$case_root/target/output/${path##*/}"
done
assert test ! -e "$case_root/injected"
expect_success check
expect_success uninstall
pass

new_case 'empty directories and directory symlink cycles'
mkdir -p "$case_root/files/tree/empty"
ln -s . "$case_root/files/tree/cycle"
ln -s missing "$case_root/files/tree/broken"
printf 'dot tree output -r\n' > "$case_root/scripts/default.sh"
expect_success install
assert test -L "$case_root/target/output/cycle"
assert test -L "$case_root/target/output/broken"
assert test ! -e "$case_root/target/output/empty"
expect_failure check
expect_success uninstall
assert test ! -L "$case_root/target/output/cycle"
assert test ! -L "$case_root/target/output/broken"
pass

new_case 'existing common aliases and per-rule root/prefix overrides'
cp "${DM%/dm}/scripts/common.sh" "$case_root/scripts/common.sh"
mkdir -p "$case_root/files/home/config/app"
printf 'data\n' > "$case_root/files/home/config/app/settings"
cat > "$case_root/scripts/default.sh" <<'EOF'
dotconf app -r
dot --files-root "$FILES_DIR/home" --files-prefix config \
    --target-root "$TARGET_DIR/custom" --target-prefix conf app -rd1
EOF
expect_success install
assert test -L "$case_root/target/.config/app/settings"
assert test -L "$case_root/target/custom/conf/app/settings"
expect_success check
pass

new_case 'copies skip existing content, force replaces it, uninstall keeps it'
printf 'new\n' > "$case_root/files/item"
printf 'old\n' > "$case_root/target/item"
printf 'dot item -c\n' > "$case_root/scripts/default.sh"
expect_success install
assert grep -qx old "$case_root/target/item"
expect_success install -f
assert cmp "$case_root/files/item" "$case_root/target/item"
assert test ! -L "$case_root/target/item"
expect_success check
expect_success uninstall
assert test -f "$case_root/target/item"
pass

new_case 'copying a directory is consistently skipped by install and check'
mkdir -p "$case_root/files/tree"
printf 'dot tree -c\n' > "$case_root/scripts/default.sh"
expect_success install
assert test ! -e "$case_root/target/tree"
expect_success check
expect_success uninstall
pass

new_case 'link conflicts preserve content on skip, no, and EOF'
printf 'new\n' > "$case_root/files/item"
printf 'old\n' > "$case_root/target/item"
printf 'dot item\n' > "$case_root/scripts/default.sh"
expect_failure install
printf 'no\n' > "$case_root/input"
expect_failure install
printf '\n' > "$case_root/input"
expect_success install
assert grep -qx old "$case_root/target/item"
expect_success install --force
assert test -L "$case_root/target/item"
pass

new_case 'blocked parent directory is skipped or rejected consistently'
printf 'data\n' > "$case_root/files/item"
printf 'block\n' > "$case_root/target/parent"
for mode in '' '-c'; do
    printf 'dot item parent/item %s\n' "$mode" > "$case_root/scripts/default.sh"
    : > "$case_root/input"
    expect_failure install
    printf '\n' > "$case_root/input"
    expect_success install
    assert grep -qx block "$case_root/target/parent"
done
pass

new_case 'missing sources and check mismatches return failure'
printf 'dot absent\n' > "$case_root/scripts/default.sh"
expect_failure install
printf 'data\n' > "$case_root/files/item"
for mode in '' '-c'; do
    printf 'dot item %s\n' "$mode" > "$case_root/scripts/default.sh"
    expect_failure check
done
ln -s "$case_root/files/elsewhere" "$case_root/target/item"
printf 'dot item\n' > "$case_root/scripts/default.sh"
expect_failure check
expect_success uninstall
assert test -L "$case_root/target/item"
pass

new_case 'uninstall removes an exact managed link after its source is deleted'
printf 'data\n' > "$case_root/files/item"
printf 'dot item\n' > "$case_root/scripts/default.sh"
expect_success install
rm "$case_root/files/item"
expect_failure check
expect_success uninstall
assert test ! -L "$case_root/target/item"
pass

new_case 'nested templates, escaping, command expansion and environment isolation'
mkdir -p "$case_root/files/home/config/xdg"
printf 'DM_TEST_VALUE=inside\n' > "$case_root/files/home/config/xdg/user-dirs.dirs"
cat > "$case_root/files/template" <<'EOF'
%$DM_TEST_VALUE%
\%$DM_TEST_VALUE%
%!printf command%
%?true%
%?false%
hidden
%;true%
nested
%:%
hidden
%?%
%?%
EOF
cat > "$case_root/scripts/default.sh" <<'EOF'
DM_TEST_VALUE=outside
export DM_TEST_VALUE
dot template nested/result -ct
[ "$DM_TEST_VALUE" = outside ]
EOF
expect_success install
printf 'inside\n%%$DM_TEST_VALUE%%\ncommand\nnested\n' > "$case_root/expected"
assert cmp "$case_root/expected" "$case_root/target/nested/result"
pass

new_case 'dot calls preserve caller state and reset per-rule options'
mkdir -p "$case_root/files/tree"
printf 'data\n' > "$case_root/files/tree/item"
cat > "$case_root/scripts/default.sh" <<'EOF'
_quote_RESULT=caller
_dot__COPY_MODE=caller
for i in first second; do
    dot tree "$i" -r
    [ "$i" = first ] || [ "$i" = second ]
done
dot tree/item copied -c
dot tree/item linked
[ "$_quote_RESULT" = caller ]
[ "$_dot__COPY_MODE" = caller ]
EOF
expect_success install
assert test -L "$case_root/target/first/item"
assert test -L "$case_root/target/second/item"
assert test ! -L "$case_root/target/copied"
assert test -L "$case_root/target/linked"
pass

new_case 'operation failures propagate even when dot is used in a condition'
printf 'data\n' > "$case_root/files/item"
for operation in cp awk ln mkdir rm unlink; do
    case "$operation" in
        cp) arguments='item copy -c'; command=install ;;
        awk) arguments='item template -ct'; command=install ;;
        ln) arguments='item link'; command=install ;;
        mkdir) arguments='item missing/child'; command=install ;;
        rm)
            printf 'existing\n' > "$case_root/target/existing"
            arguments='item existing -f'; command=install ;;
        unlink)
            ln -s "$case_root/files/item" "$case_root/target/managed"
            arguments='item managed'; command=uninstall ;;
    esac
    cat > "$case_root/scripts/default.sh" <<EOF
$operation() { return 7; }
if dot $arguments; then
    exit 99
fi
:
EOF
    expect_success "$command"
done
pass

new_case 'recursive errors are not masked by a later successful entry'
mkdir -p "$case_root/files/tree"
printf 'data\n' > "$case_root/files/tree/a"
printf 'data\n' > "$case_root/files/tree/b"
cat > "$case_root/scripts/default.sh" <<'EOF'
cp() { case "$2" in */a) return 7 ;; *) command cp "$@" ;; esac; }
if dot tree output -rc; then
    exit 99
fi
:
EOF
expect_success install
pass

printf '%s regression cases passed with %s\n' "$case_number" "$DM_SHELL"
