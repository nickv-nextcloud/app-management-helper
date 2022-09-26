#!/bin/bash
#
# Checkout and update the branch on all repos

set -e

PACKAGE_VERSION=$1
HEAD_BRANCH=$1
if [[ "$HEAD_BRANCH" = "master" ]]; then
	HEAD_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
fi
BRANCH_NAME=migrate-$HEAD_BRANCH-christophwurst-package

echo "Fetch $HEAD_BRANCH"
echo "======================"
git fetch origin $HEAD_BRANCH

echo "Checkout $HEAD_BRANCH"
echo "======================"
git checkout $HEAD_BRANCH

echo "Reset $HEAD_BRANCH"
echo "======================"
git reset --hard origin/$HEAD_BRANCH

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

echo ""
echo "Migrate previous files"
echo "======================"

if [ -f .github/workflows/update-christophwurst-nextcloud.yml ]; then
	git rm .github/workflows/update-christophwurst-nextcloud.yml

	wget -O .github/workflows/update-nextcloud-ocp.yml https://raw.githubusercontent.com/nextcloud/.github/master/workflow-templates/update-nextcloud-ocp.yml
	git add .github/workflows/update-nextcloud-ocp.yml
fi

if [ -f .github/workflows/psalm.yml ]; then
	wget -O .github/workflows/psalm.yml https://raw.githubusercontent.com/nextcloud/.github/master/workflow-templates/psalm.yml
	git add .github/workflows/psalm.yml
fi

if [ -f .github/workflows/static-analysis.yml ]; then
	git rm .github/workflows/static-analysis.yml
	wget -O .github/workflows/psalm.yml https://raw.githubusercontent.com/nextcloud/.github/master/workflow-templates/psalm.yml
	git add .github/workflows/psalm.yml
fi

composer remove --no-update --dev christophwurst/nextcloud
composer require --dev nextcloud/ocp:dev-$PACKAGE_VERSION

git add composer.*

echo ""
echo "Commit branch"
echo "======================"
git commit -m "Migrate to nextcloud/OCP package in $HEAD_BRANCH

Signed-off-by: Joas Schilling <coding@schilljs.com>"

echo ""
echo "Push branch"
echo "======================"
git push origin $BRANCH_NAME

echo ""
echo "Create PR"
echo "======================"
gh pr create --base $HEAD_BRANCH --fill >> ../../pr-list.txt

