#!/bin/bash
#
# Checkout and update the branch on all repos

set -e

DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
REPO=${PWD##*/}

echo "Fetch $DEFAULT_BRANCH"
echo "======================"
git fetch origin $DEFAULT_BRANCH

echo "Checkout $DEFAULT_BRANCH"
echo "======================"
git checkout $DEFAULT_BRANCH

echo "Checkout $DEFAULT_BRANCH"
echo "======================"
git reset --hard origin/$DEFAULT_BRANCH

set +e

echo ""
echo "Delete existing branch"
echo "======================"
git branch -D update-$DEFAULT_BRANCH-version

set -e

echo ""
echo "Checkout branch"
echo "======================"
git checkout -b update-$DEFAULT_BRANCH-version

CHANGED="0"
for FILE in appinfo/info.xml
do
  if [ -f $FILE ]; then
    echo ""
    echo "Update $FILE"
    echo "======================"
    gedit $FILE

    echo ""
    echo "Add file to git status"
    echo "======================"
    git add $FILE
    CHANGED="1"
  fi
done

echo ""
echo "Commit branch"
echo "======================"
git commit -m "Update version on $DEFAULT_BRANCH

Signed-off-by: Joas Schilling <coding@schilljs.com>"

echo ""
echo "Push branch"
echo "======================"
git push --force origin update-$DEFAULT_BRANCH-version

echo ""
echo "Create PR"
echo "======================"
gh pr create --base $DEFAULT_BRANCH --fill >> ../../pr-list.txt
