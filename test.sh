#!/bin/sh


export USECLI_BIN_DIR=`mktemp -d`
export USECLI_TARGET_DIR=`mktemp -d`
export USECLI_TESTDIR=`mktemp -d`

cleanup () {
rm -rf "$USECLI_BIN_DIR"
rm -rf "$USECLI_TARGET_DIR"
rm -rf "$USECLI_TESTDIR"
}

fail () {
echo "FAIL:" "$@" >&2
cleanup
exit 1
}

use="./use"

sh -n "$use" || fail "did not compile"

"$use" 2>&1 && fail "did not set error code"

mkdir "$USECLI_TARGET_DIR/dir"
touch "$USECLI_BIN_DIR/dir-1"
"$use" dir 1 2>&1 && fail "tried to overwrite directory"

touch "$USECLI_TARGET_DIR/file"
touch "$USECLI_BIN_DIR/file-1"
"$use" file 1 2>&1 && fail "tried to overwrite regular file"

ln -s /dev/null "$USECLI_TARGET_DIR/link"
touch "$USECLI_BIN_DIR/link-1" "$USECLI_BIN_DIR/link-2"
"$use" link 1 || fail "failed to link valid file"
test -L "$USECLI_TARGET_DIR/link" || fail "failed to link valid file (no link)"
test `readlink -n "$USECLI_TARGET_DIR/link"` = "$USECLI_BIN_DIR/link-1" || \
    fail "failed to link valid file (wrong target)"
"$use" link 2 || fail "failed to link valid file"
test -L "$USECLI_TARGET_DIR/link" || fail "failed to link valid file 2 (no link)"
test `readlink -n "$USECLI_TARGET_DIR/link"` = "$USECLI_BIN_DIR/link-2" || \
    fail "failed to link valid file 2 (wrong target)"
"$use" link 3 2>&1 && fail "tried to link invalid file"
test -L "$USECLI_TARGET_DIR/link" || fail "invalid invocation removed an existing link"
test `readlink -n "$USECLI_TARGET_DIR/link"` = "$USECLI_BIN_DIR/link-2" || \
    fail "invalid invocation changed the target of an existing link"



cat >"$USECLI_TESTDIR/expected" <<EOF
link-1
link-2
EOF

"$use" link >"$USECLI_TESTDIR/actual"
diff "$USECLI_TESTDIR/expected" "$USECLI_TESTDIR/actual" || fail "wrong list of available binaries"

cleanup
