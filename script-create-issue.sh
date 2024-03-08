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
#gh issue create -t "Please update github action workflows" -b "At least [update-nextcloud-ocp.yml](https://github.com/nextcloud/.github/blob/master/workflow-templates/update-nextcloud-ocp.yml) needs to be updated so you are informed about failures. My recent PR purged your composer.lock to allow installing the latest version, but you will miss when this breaks again, unless the action template is updated to the latest" >> ../../pr-list.txt

echo $APP_ID  >> ../../pr-list.txt


