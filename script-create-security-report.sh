#!/bin/bash
#
# Checkout and update the branch on all repos

set -e

REPO=${PWD##*/}
PACKAGE_VERSION=$1
HEAD_BRANCH=$1
if [[ "$HEAD_BRANCH" = "master" ]]; then
	HEAD_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
fi

echo ""
echo "Fetch $HEAD_BRANCH"
echo "======================"
git fetch origin $HEAD_BRANCH

echo ""
echo "Reset $HEAD_BRANCH"
echo "======================"
git reset --hard origin/$HEAD_BRANCH

echo ""
echo "Check composer.json existance"
echo "======================"

if [ ! -f composer.json ]; then
	echo "- [x] $REPO: 🏳️ No composer.json" >> ../../security-report.txt
	echo ""
	echo "🏳️ No composer.json"
	echo ""
	exit 0
fi

echo ""
echo "Install or update roave/security-advisories to check for vulnerabilities"
echo "======================"

set +e
composer require --dev roave/security-advisories:dev-latest
INSTALL_FAILED=$?
set -e

if [ "$INSTALL_FAILED" = "0" ]; then
	echo "- [x] $REPO: ✅ No vulnerable depdendency" >> ../../security-report.txt
	echo ""
	echo "✅ All packages okay!"
	echo ""
else
	echo "- [ ] $REPO: ❌ Has at least one vulnerable depdendency" >> ../../security-report.txt
	echo ""
	echo "❌ $REPO is depending on insecure package"
	echo ""
fi

