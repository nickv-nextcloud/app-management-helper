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

echo "" >> ../../security-report.txt
echo "## [$REPO](https://github.com/nextcloud/$REPO) - [Security tab](https://github.com/nextcloud/$REPO/security/dependabot)" >> ../../security-report.txt
echo "" >> ../../security-report.txt


echo ""
echo "Check composer.json"
echo "======================"

COMPOSER_AUDIT=""
if [ ! -f composer.json ]; then
	echo "- [x] ⚙️ PHP: 🏳️ No composer.json" >> ../../security-report.txt
	echo ""
	echo "🏳️ No composer.json"
	echo ""
else
	set +e
	composer install --no-dev
	COMPOSER_AUDIT=$(composer audit 2>&1)
	AUDIT_FAILED=$?
	set -e

	if [ "$AUDIT_FAILED" = "0" ]; then
		echo "- [x] ⚙️ PHP: 🟢 No vulnerable depdendency" >> ../../security-report.txt
		echo ""
		echo "🟢 All ⚙️ PHP packages okay!"
		echo ""
	else
		echo "- [ ] ⚙️ PHP: ❌ Has at least one vulnerable depdendency" >> ../../security-report.txt
		echo ""
		echo "❌ $REPO is depending on insecure ⚙️ PHP package"
		echo ""
	fi
fi

NPM_AUDIT=""
if [ ! -f package.json ]; then
	echo "- [x] 🖌️ JS: 🏳️ No package.json" >> ../../security-report.txt
	echo ""
	echo "🏳️ No package.json"
	echo ""
else
	set +e
	NPM_AUDIT=$(npm audit)
	AUDIT_FAILED=$?
	set -e

	if [ "$AUDIT_FAILED" = "0" ]; then
		echo "- [x] 🖌️ JS: 🟢 No vulnerable depdendency" >> ../../security-report.txt
		echo ""
		echo "🟢 All 🖌️ JS packages okay!"
		echo ""
	else
		echo "- [ ] 🖌️ JS: ❌ Has at least one vulnerable depdendency" >> ../../security-report.txt
		echo ""
		echo "❌ $REPO is depending on insecure 🖌️ JS package"
		echo ""
	fi
fi

if [ "$COMPOSER_AUDIT$NPM_AUDIT" ]; then
	echo "" >> ../../security-report.txt
	echo "<details>" >> ../../security-report.txt
	echo "" >> ../../security-report.txt

	if [ "$COMPOSER_AUDIT" ]; then
		echo "### Composer" >> ../../security-report.txt
		echo "\`\`\`" >> ../../security-report.txt
		echo "$COMPOSER_AUDIT" >> ../../security-report.txt
		echo "\`\`\`" >> ../../security-report.txt
		echo "" >> ../../security-report.txt
	fi

	if [ "$NPM_AUDIT" ]; then
		echo "### NPM" >> ../../security-report.txt
		echo "\`\`\`" >> ../../security-report.txt
		echo "$NPM_AUDIT" >> ../../security-report.txt
		echo "\`\`\`" >> ../../security-report.txt
		echo "" >> ../../security-report.txt
	fi
	echo "</details>" >> ../../security-report.txt
	echo "" >> ../../security-report.txt
fi

echo "" >> ../../security-report.txt



