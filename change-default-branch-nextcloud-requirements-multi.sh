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
            renovate.json \
            .github/dependabot.yml \
            .github/workflows/phpunit-mysql.yml \
            .github/workflows/phpunit-sqlite.yml \
            .github/workflows/npm-audit-fix.yml \
            .github/workflows/update-nextcloud-ocp-matrix.yml \
            .github/workflows/psalm-matrix.yml
do
  if [ -f $FILE ]; then
    if [[ "$FILE" = "package.json" ]]; then
      npm version --no-git-tag-version $(xmllint --xpath '/info/version/text()' appinfo/info.xml)
      git diff
      git add package.json
      git add package-lock.json
    fi

    echo ""
    echo "Update $FILE"
    echo "======================"
    gnome-text-editor $FILE

    echo ""
    echo "Add file to git status"
    echo "======================"
    git add $FILE
    CHANGED="1"
  fi
done

set +e

git status

if [[ "$CHANGED" = "0" ]]; then
    echo -e "\033[1;35m🏳 No update needed\033[0m"
    exit 1
fi

echo ""
echo "Commit branch"
echo "======================"
git commit -m "feat(deps): Add Nextcloud $NEW_VERSION support

Signed-off-by: Joas Schilling <coding@schilljs.com>"

echo ""
echo "Push branch"
echo "======================"
git push --force origin update-$DEFAULT_BRANCH-version

echo ""
echo "Create PR"
echo "======================"
gh pr create --base $DEFAULT_BRANCH --fill >> ../../pr-list.txt
