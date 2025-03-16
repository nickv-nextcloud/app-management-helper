#!/bin/bash
#
# Checkout and update the branch on all repos

set -e

REPO=${PWD##*/}
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
PACKAGE_VERSION=$1
HEAD_BRANCH=$1
SKIP_MAINTAINERS=$2

if [[ "$HEAD_BRANCH" = "master" ]]; then
	HEAD_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
fi

MAINTAINERS='@AndyScherzinger @sorbaugh'
if [ "$SKIP_MAINTAINERS" = "0" ]; then
  MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

  echo ""
  echo "Read maintainers from main branch $MAIN_BRANCH"
  echo "======================"
  git fetch origin $MAIN_BRANCH

  git checkout $MAIN_BRANCH
  git reset --hard origin/$MAIN_BRANCH

  if [ ! -f CODEOWNERS ]; then
    if [ ! -f .github/CODEOWNERS ]; then
      if [ ! -f docs/CODEOWNERS ]; then
        echo -e "\033[0;31m❌ $REPO is missing the CODEOWNERS file\033[0m"
        CODEOWNER_FILE='.github/CODEOWNERS'
        touch $CODEOWNER_FILE
      else
        CODEOWNER_FILE='docs/CODEOWNERS'
      fi
    else
      CODEOWNER_FILE='.github/CODEOWNERS'
    fi
  else
    CODEOWNER_FILE='CODEOWNERS'
  fi

  if [ -f $CODEOWNER_FILE ]; then
    echo -e "\033[0;36mReading maintainers from $CODEOWNER_FILE\033[0m"
    INFOXML_OWNER=$(cat $CODEOWNER_FILE | egrep -oEi '^/appinfo/info.xml\s+@(.*)' | wc -l)
    if [ "$INFOXML_OWNER" = "0" ]; then
      echo -e "\033[0;31m❌ $REPO is missing the CODEOWNERS for info.xml\033[0m"
    fi
    MAINTAINERS=$(cat $CODEOWNER_FILE | egrep -oEi '^/appinfo/info.xml\s+@(.*)' | egrep -oEi '\s+@(.*)' | xargs)
    echo -e "\033[1;35mMaintainers $MAINTAINERS\033[0m"
  else
    echo -e "\033[0;31m❌ $REPO is missing the CODEOWNERS\033[0m"
  fi
else
  echo -e "\033[1;35mMaintainers skipped, falling back to $MAINTAINERS\033[0m"
fi

echo ""
echo "Detecting matching stable branch"
echo "======================"
if [ "${HEAD_BRANCH:0:6}" = "stable" ]; then
  # https://github.com/nextcloud/guests/pull/1096#issuecomment-1881215509
  HEAD_BRANCH=$(find-stable ${HEAD_BRANCH:6})
fi

echo ""
echo "Fetch $HEAD_BRANCH"
echo "======================"
git fetch origin $HEAD_BRANCH

echo ""
echo "Checkout $HEAD_BRANCH"
echo "======================"
git checkout $HEAD_BRANCH

echo ""
echo "Reset $HEAD_BRANCH"
echo "======================"
git reset --hard origin/$HEAD_BRANCH

echo "" >> $SCRIPT_DIR/security-report.txt
echo "## [$REPO](https://github.com/nextcloud/$REPO) - [Security tab](https://github.com/nextcloud/$REPO/security/dependabot)" >> $SCRIPT_DIR/security-report.txt
echo "" >> $SCRIPT_DIR/security-report.txt

echo ""
echo "Check GitHub workflows"
echo "======================"

WORKFLOWS_AUDIT=""
if [ ! -d .github/workflows ]; then
	echo "- [x] 🐈 GitHub Actions: 🏳️ No workflows" >> $SCRIPT_DIR/security-report.txt
	echo ""
	echo -e "\033[1;35m🏳️  No workflows\033[0m"
	echo ""
else
	set +e
	# zizmor
	WORKFLOWS_AUDIT=$(zizmor .github/workflows/*.yml --min-severity medium | grep ' findings')
	WORKFLOWS_AUDIT_STAT=$(echo $WORKFLOWS_AUDIT | grep -v 'No findings to report' | wc -l)
	if [ "$WORKFLOWS_AUDIT_STAT" != "0" ]; then
		ZIZMOR_VERSION=$(zizmor --version)
		WORKFLOWS_AUDIT=$(echo -e "Workflow scan summary of $ZIZMOR_VERSION:\n$WORKFLOWS_AUDIT")
	fi

	# action pinning
	WORKFLOWS_PINNED_VERSION=$(grep -E '[ ]*[ -] uses: ' .github/workflows/* | grep -vE '@[0-9a-f]{32}' | grep -vE 'uses: (actions|shivammathur|docker|cypress-io|buildjet|skjnldsv|ChristophWurst|nextcloud-releases|cachix|\.)/')
	WORKFLOWS_PINNED_VERSION_STAT=$(echo "$WORKFLOWS_PINNED_VERSION" | grep "uses" | wc -l)
	if [ "$WORKFLOWS_PINNED_VERSION_STAT" != "0" ]; then
		WORKFLOWS_PINNED_VERSION=$(echo -e "Workflow files reference tags by version number or branch names instead of SHA of tags:\n$WORKFLOWS_PINNED_VERSION")
	fi

	set -e

	if [ "$WORKFLOWS_AUDIT_STAT" = "0" -a "$WORKFLOWS_PINNED_VERSION_STAT" = "0" ]; then
		WORKFLOWS_AUDIT=""
		echo "- [x] 🐈 GitHub Actions: 🟢 No insecure Actions" >> $SCRIPT_DIR/security-report.txt
		echo ""
		echo -e "\033[0;32m🟢 All 🐈 GitHub Actions okay!\033[0m"
		echo ""
	else
	  WORKFLOWS_AUDIT=$(echo -e "$WORKFLOWS_AUDIT\n\n$WORKFLOWS_PINNED_VERSION")
		echo "- [ ] 🐈 GitHub Actions: ❌ Has at least one insecure Action" >> $SCRIPT_DIR/security-report.txt
		echo "  - Maintainers: $MAINTAINERS" >> $SCRIPT_DIR/security-report.txt
		echo ""
		echo -e "\033[0;31m❌ $REPO has insecure 🐈 GitHub Actions\033[0m"
		echo ""
	fi
fi

echo ""
echo "Check composer.json"
echo "======================"

COMPOSER_AUDIT=""
if [ ! -f composer.json ]; then
	echo "- [x] ⚙️ PHP: 🏳️ No composer.json" >> $SCRIPT_DIR/security-report.txt
	echo ""
	echo -e "\033[1;35m🏳️  No composer.json\033[0m"
	echo ""
else
	set +e
	COMPOSER_AUDIT=$(composer audit --locked --no-ansi --no-interaction 2>&1)
	AUDIT_FAILED=$?
	set -e

	if [ "$AUDIT_FAILED" = "0" ]; then
		echo "- [x] ⚙️ PHP: 🟢 No vulnerable dependency" >> $SCRIPT_DIR/security-report.txt
		echo ""
		echo -e "\033[0;32m🟢 All ⚙️  PHP packages okay!\033[0m"
		echo ""
	else
		echo "- [ ] ⚙️ PHP: ❌ Has at least one vulnerable dependency" >> $SCRIPT_DIR/security-report.txt
		echo "  - Maintainers: $MAINTAINERS" >> $SCRIPT_DIR/security-report.txt
		echo ""
		echo -e "\033[0;31m❌ $REPO is depending on insecure ⚙️  PHP package\033[0m"
		echo ""
	fi
fi

echo ""
echo "Check package.json"
echo "======================"

NPM_AUDIT=""
if [ ! -f package.json ]; then
	echo "- [x] 🖌️ JS: 🏳️ No package.json" >> $SCRIPT_DIR/security-report.txt
	echo ""
	echo -e "\033[1;35m🏳️  No package.json\033[0m"
	echo ""
else
	set +e
	NPM_AUDIT_ONLY=$(npm audit --package-lock-only --omit optional --omit dev)
	AUDIT_FAILED=$?
	# Run again with grep filter on the output
	NPM_AUDIT=$(npm audit --package-lock-only --omit optional --omit dev | egrep -v '^\s{2,}[a-zA-Z@]')
	set -e

	if [ "$AUDIT_FAILED" = "0" ]; then
		echo "- [x] 🖌️ JS: 🟢 No vulnerable dependency" >> $SCRIPT_DIR/security-report.txt
		echo ""
		echo -e "\033[0;32m🟢 All 🖌️ JS packages okay!\033[0m"
		echo ""
	else
		echo "- [ ] 🖌️ JS: ❌ Has at least one vulnerable dependency" >> $SCRIPT_DIR/security-report.txt
		echo "  - Maintainers: $MAINTAINERS" >> $SCRIPT_DIR/security-report.txt
		echo ""
		echo -e "\033[0;31m❌ $REPO is depending on insecure 🖌️ JS package\033[0m"
		echo ""
	fi
fi

if [ "$COMPOSER_AUDIT$NPM_AUDIT" ]; then
	echo "" >> $SCRIPT_DIR/security-report.txt
	echo "<details>" >> $SCRIPT_DIR/security-report.txt
	echo "" >> $SCRIPT_DIR/security-report.txt

	if [ "$WORKFLOWS_AUDIT" ]; then
		echo "### GitHub Actions" >> $SCRIPT_DIR/security-report.txt
		echo "\`\`\`" >> $SCRIPT_DIR/security-report.txt
		echo "$WORKFLOWS_AUDIT" >> $SCRIPT_DIR/security-report.txt
		echo "\`\`\`" >> $SCRIPT_DIR/security-report.txt
		echo "" >> $SCRIPT_DIR/security-report.txt
	fi

	if [ "$COMPOSER_AUDIT" ]; then
		echo "### Composer" >> $SCRIPT_DIR/security-report.txt
		echo "\`\`\`" >> $SCRIPT_DIR/security-report.txt
		echo "$COMPOSER_AUDIT" >> $SCRIPT_DIR/security-report.txt
		echo "\`\`\`" >> $SCRIPT_DIR/security-report.txt
		echo "" >> $SCRIPT_DIR/security-report.txt
	fi

	if [ "$NPM_AUDIT" ]; then
		echo "### NPM" >> $SCRIPT_DIR/security-report.txt
		echo "\`\`\`" >> $SCRIPT_DIR/security-report.txt
		echo "$NPM_AUDIT" >> $SCRIPT_DIR/security-report.txt
		echo "\`\`\`" >> $SCRIPT_DIR/security-report.txt
		echo "" >> $SCRIPT_DIR/security-report.txt
	fi
	echo "</details>" >> $SCRIPT_DIR/security-report.txt
	echo "" >> $SCRIPT_DIR/security-report.txt
fi

echo "" >> $SCRIPT_DIR/security-report.txt



