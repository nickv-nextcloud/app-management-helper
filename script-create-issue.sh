#!/bin/bash
#
# Checkout the default branch, checks for existance of a file and creates an issue based on it

set -e

DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
APP_ID=${PWD##*/}

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

if [ ! -f .github/workflows/app-code-check.yml ]; then
    echo "No .github/workflows/app-code-check.yml"
    exit 1
fi

echo ""
echo "Creating issue"
echo "======================"
#gh issue create -t "Replace Travis with GitHub Actions" -b "Travis has stopped their free service. Please switch to GitHub Actions to continue CI testing. Check the app-tutorial app for some nice examples how to run basic phpunit tests and other things there: https://github.com/nextcloud/app-tutorial/tree/master/.github/workflows" >> ../../pr-list.txt

echo $APP_ID  >> ../../pr-list.txt


