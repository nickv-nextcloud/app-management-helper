#!/bin/bash
#
# Create the stable* branch for repos based on master

BRANCH=$1

set -e


DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

echo -e "\033[1;35m🏳 Default branch: $DEFAULT_BRANCH\033[0m"

echo "Fetch $DEFAULT_BRANCH"
echo "======================"
git fetch origin $DEFAULT_BRANCH

echo "Checkout $DEFAULT_BRANCH"
echo "======================"
git checkout $DEFAULT_BRANCH

echo "Reset $DEFAULT_BRANCH"
echo "======================"
git reset --hard origin/$DEFAULT_BRANCH

echo "Checkout $BRANCH"
echo "======================"
git checkout -b $BRANCH
git push origin $BRANCH

echo -e "\033[0;32m🟢 $BRANCH created\033[0m"
