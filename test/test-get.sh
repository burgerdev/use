#!/bin/sh

set -u

export GETCLI_HELPER_DIR=`mktemp -d`
export USECLI_BIN_DIR=`mktemp -d`
export GETCLI_TESTDIR=`mktemp -d`

cleanup () {
set +u
if [ -n "$GETCLI_DEBUG" ]
then
return 0
fi
rm -rf "$GETCLI_HELPER_DIR"
rm -rf "$USECLI_BIN_DIR"
rm -rf "$GETCLI_TESTDIR"
}

fail () {
echo "FAIL:" "$@" >&2
cleanup
exit 1
}

get="./get"

sh -n "$get" || fail "did not compile"

"$get" 2>&1 && fail "did not set error code"

ln -s "`pwd`/examples/helper-dummy.sh" "$GETCLI_HELPER_DIR/get-dummy"
"$get" dummy 1 2>&1 || fail "failed to produce dummy-1"
"$get" dummy 1 2>&1 && fail "tried to overwrite existing dummy-1"
"$get" dummy 2 2>&1 || fail "failed to produce dummy-2"

for i in 1 2
do
echo $i >"$GETCLI_TESTDIR/expected-$i" 
"$USECLI_BIN_DIR/dummy-$i" >"$GETCLI_TESTDIR/actual-$i"
diff "$GETCLI_TESTDIR/expected-$i" "$GETCLI_TESTDIR/actual-$i" || fail "wrong binary $i"
done

cleanup
