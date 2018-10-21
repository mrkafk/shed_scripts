#!/bin/bash

# Checkout files modified or modified and added between two commits to a temp dir. Default is modified only.

TMPD="/tmp/$$.gcmf"
TMPIDX="/tmp/$$.gitidx"
TMPF="/tmp/$$.flist"
COMMIT1="$1"
COMMIT2="$2"
TOPLEVEL=$(git rev-parse --show-toplevel)

if [ -z "$COMMIT1" ]; then
    echo "Specify first commit as first argument."
    exit 1
fi

if [ -z "$COMMIT2" ]; then
    echo "Specify second commit as second argument."
    exit 1
fi

if [ "$3" == '--added-too' ]; then
    echo "Files ADDED AND MODIFIED between commit $COMMIT1 and commit $COMMIT2"
    git diff "$COMMIT1" "$COMMIT2" --name-status > "$TMPF"
else
    echo "Files MODIFIED (only) between commit $COMMIT1 and commit $COMMIT2"
    git diff "$COMMIT1" "$COMMIT2" --name-status | egrep '^M' | sed 's/^M\s*//g'> "$TMPF"
fi

cat "$TMPF"
echo

mkdir -p "$TMPD"

set -x
git --git-dir="$TOPLEVEL/.git" --work-tree="$TMPD" checkout -- $(cat "$TMPF")
set +x

echo
echo "Files checked out to $TMPD"

rm -rf "$TMPIDX" "$TMPF"
