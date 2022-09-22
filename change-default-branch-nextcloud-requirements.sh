#!/bin/bash
#
# Checkout and update the branch on all repos

NEW_VERSION=$1

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

echo ""
echo "Delete existing branch"
echo "======================"
git branch -D update-$DEFAULT_BRANCH-version

echo ""
echo "Checkout branch"
echo "======================"
git checkout -b update-$DEFAULT_BRANCH-version

set -e

CHANGED="0"
for FILE in appinfo/info.xml \
            package.json \
            .github/workflows/update-christophwurst-nextcloud.yml
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

set +e

if [[ "$CHANGED" = "0" ]]; then
    echo "No update needed"
    exit 1
fi

echo ""
echo "Commit branch"
echo "======================"
git commit -m "Add Nextcloud $NEW_VERSION support on $DEFAULT_BRANCH

Signed-off-by: Joas Schilling <coding@schilljs.com>"

echo ""
echo "Push branch"
echo "======================"
git push --force origin update-$DEFAULT_BRANCH-version

echo ""
echo "Create PR"
echo "======================"
gh pr create --base $DEFAULT_BRANCH --fill >> ../../pr-list.txt
