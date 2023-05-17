#!/bin/bash
#
# Checkout and update the branch on all repos

CORE_BRANCH=$1
VERSION=$2

set -e

echo "Fetch $CORE_BRANCH"
echo "======================"
git fetch origin $CORE_BRANCH

echo "Checkout $CORE_BRANCH"
echo "======================"
git checkout $CORE_BRANCH

echo "Reset $CORE_BRANCH"
echo "======================"
git reset --hard origin/$CORE_BRANCH

set +e

echo ""
echo "Delete existing branch"
echo "======================"
git branch -D update-$CORE_BRANCH-target-versions

set -e

echo ""
echo "Checkout branch"
echo "======================"
git checkout -b update-$CORE_BRANCH-target-versions

CHANGED="0"
for FILE in .travis.yml \
            .drone.yml \
            .github/workflows/oci.yml \
            .github/workflows/phpunit.yml \
            .github/workflows/phpunit-mysql.yml \
            .github/workflows/phpunit-oci.yml \
            .github/workflows/phpunit-pgsql.yml \
            .github/workflows/phpunit-sqlite.yml \
            .github/workflows/integration.yml \
            .github/workflows/static-analysis.yml \
            .github/workflows/php-test.yml \
            .github/workflows/test.yml \
            .github/workflows/psalm.yml
do
  if [ -f $FILE ]; then
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

git status

if [[ "$CHANGED" = "0" ]]; then
    echo -e "\033[1;35m🏳 No update needed\033[0m"
    exit 1
fi

echo ""
echo "Commit branch"
echo "======================"
git commit -m "chore(CI): Adjust testing matrix for Nextcloud $VERSION on $CORE_BRANCH

Signed-off-by: Joas Schilling <coding@schilljs.com>"

echo ""
echo "Push branch"
echo "======================"
git push --force origin update-$CORE_BRANCH-target-versions

echo ""
echo "Create PR"
echo "======================"
gh pr create --base $CORE_BRANCH --fill >> ../../pr-list.txt

