#!/bin/bash
#
# Checkout and update the branch on all repos

set -e

DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
BRANCH_NAME=update-$DEFAULT_BRANCH-phpunit-config

echo "Fetch $DEFAULT_BRANCH"
echo "======================"
git fetch origin $DEFAULT_BRANCH

echo "Checkout $DEFAULT_BRANCH"
echo "======================"
git checkout $DEFAULT_BRANCH

echo "Reset $DEFAULT_BRANCH"
echo "======================"
git reset --hard origin/$DEFAULT_BRANCH

set +e

echo ""
echo "Delete existing branch"
echo "======================"
git branch -D $BRANCH_NAME

set -e

echo ""
echo "Checkout branch"
echo "======================"
git checkout -b $BRANCH_NAME


CHANGED="0"
for FILE in phpunit.xml \
            tests/phpunit.xml \
            tests/phpunit/phpunit.xml \
            tests/php/phpunit.xml \
            tests/unit/phpunit.xml \
            tests/Unit/phpunit.xml \
            phpunit.integration.xml \
            tests/phpunit.integration.xml \
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
    gedit $FILE

    echo ""
    echo "Add file to git status"
    echo "======================"
    git add $FILE
    CHANGED="1"
  fi
done

if [[ "$CHANGED" = "0" ]]; then
    echo "No testing"
    exit 1
fi

echo ""
echo "Commit branch"
echo "======================"
git commit -m "Adjust phpunit config in $DEFAULT_BRANCH

Signed-off-by: Joas Schilling <coding@schilljs.com>"

echo ""
echo "Push branch"
echo "======================"
git push origin $BRANCH_NAME

echo ""
echo "Create PR"
echo "======================"
gh pr create --base $DEFAULT_BRANCH --fill >> ../../pr-list.txt

