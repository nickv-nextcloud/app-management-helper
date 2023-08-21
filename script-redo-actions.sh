#!/bin/bash
#
# Checkout and update the branch on all repos

set -e

DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
BRANCH_NAME=update-$DEFAULT_BRANCH-php-testing-versions

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
for FILE in appstore-build-publish.yml \
            command-compile.yml \
            command-rebase.yml \
            dependabot-approve-merge.yml \
            fixup.yml \
            lint.yml \
            lint-eslint.yml \
            lint-info-xml.yml \
            lint-php.yml \
            lint-php-cs.yml \
            lint-stylelint.yml \
            node.yml \
            npm-publish.yml \
            phpunit.yml \
            phpunit-mysql.yml \
            phpunit-oci.yml \
            phpunit-pgsql.yml \
            phpunit-sqlite.yml \
            phpunit-summary-when-unrelated.yml \
            static-analysis.yml \
            psalm.yml \
            psalm-matrix.yml \
            update-christophwurst-nextcloud.yml \
            update-nextcloud-ocp.yml \
            update-nextcloud-ocp-matrix.yml
do
    echo ""
    echo "Loop: $FILE"
    echo "======================"

  if [[ "$FILE" = "static-analysis.yml" ]]; then
    if [ -f '.github/workflows/static-analysis.yml' ]; then
      cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/psalm-matrix.yml .github/workflows/psalm-matrix.yml
      mv .github/workflows/static-analysis.yml .github/workflows/psalm-matrix.yml
      git add .github/workflows/
    fi
    continue
  fi

  if [[ "$FILE" = "update-christophwurst-nextcloud.yml" ]]; then
    if [ -f '.github/workflows/update-christophwurst-nextcloud.yml' ]; then
      gh repo set-default
      gh issue create -t "Replace christophwurst/nextcloud package with nextcloud/ocp" -b "See the update-nextcloud-ocp.yml or update-nextcloud-ocp-matrix.yml (for multi version support) in https://github.com/nextcloud/.github/tree/master/workflow-templates"
    fi
    continue
  fi

  if [[ "$FILE" = "lint.yml" ]]; then
    if [ -f '.github/workflows/lint.yml' ]; then
      gh repo set-default
      gh issue create -t "Replace lint.yml with split workflows" -b "See the lint-*.yml files in https://github.com/nextcloud/.github/tree/master/workflow-templates"
    fi
    continue
  fi


  if [[ "$FILE" = "phpunit.yml" ]]; then
    if [ -f '.github/workflows/phpunit.yml' ]; then
      gh repo set-default
      gh issue create -t "Replace phpunit.yml with split workflows" -b "See the phpunit-*.yml files in https://github.com/nextcloud/.github/tree/master/workflow-templates"
    fi
    continue
  fi

  if [ -f ".github/workflows/$FILE" ]; then
    echo ""
    echo "Copy workflow-templates/$FILE"
    echo "======================"
    cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/$FILE .github/workflows/$FILE

    if [[ "$FILE" = "node.yml" ]]; then
      cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/node-when-unrelated.yml .github/workflows/node-when-unrelated.yml
      git add .github/workflows/node-when-unrelated.yml
    fi

    if [[ "$FILE" = "lint-eslint.yml" ]]; then
      cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/lint-eslint-when-unrelated.yml .github/workflows/lint-eslint-when-unrelated.yml
      git add .github/workflows/lint-eslint-when-unrelated.yml
    fi

    if [[ "$FILE" = "phpunit-mysql.yml" ]]; then
      if [ ! -f '.github/workflows/phpunit-summary-when-unrelated.yml' ]; then
        cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/phpunit-summary-when-unrelated.yml .github/workflows/phpunit-summary-when-unrelated.yml
        git add .github/workflows/phpunit-summary-when-unrelated.yml
      fi
    fi
    if [[ "$FILE" = "phpunit-oci.yml" ]]; then
      if [ ! -f '.github/workflows/phpunit-summary-when-unrelated.yml' ]; then
        cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/phpunit-summary-when-unrelated.yml .github/workflows/phpunit-summary-when-unrelated.yml
        git add .github/workflows/phpunit-summary-when-unrelated.yml
      fi
    fi
    if [[ "$FILE" = "phpunit-pgsql.yml" ]]; then
      if [ ! -f '.github/workflows/phpunit-summary-when-unrelated.yml' ]; then
        cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/phpunit-summary-when-unrelated.yml .github/workflows/phpunit-summary-when-unrelated.yml
        git add .github/workflows/phpunit-summary-when-unrelated.yml
      fi
    fi
    if [[ "$FILE" = "phpunit-sqlite.yml" ]]; then
      if [ ! -f '.github/workflows/phpunit-summary-when-unrelated.yml' ]; then
        cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/phpunit-summary-when-unrelated.yml .github/workflows/phpunit-summary-when-unrelated.yml
        git add .github/workflows/phpunit-summary-when-unrelated.yml
      fi
      if [ ! -f '.github/workflows/phpunit-mysql.yml' ]; then
        cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/phpunit-sqlite-all-versions.yml .github/workflows/phpunit-sqlite.yml
      fi
    fi

    echo ""
    echo "Diff .github/workflows/$FILE"
    echo "======================"
    git --no-pager diff .github/workflows/$FILE

    echo ""
    echo "Update .github/workflows/$FILE"
    echo "======================"
    gedit .github/workflows/$FILE

    echo ""
    echo "Add file to git status"
    echo "======================"
    git add .github/workflows/$FILE
    CHANGED="1"
  fi
done


FILE="composer.json"
if [ -f $FILE ]; then
      echo "COMPOSER.JSON"
      echo "COMPOSER.JSON"
      echo "COMPOSER.JSON"
      echo "COMPOSER.JSON"
      echo "COMPOSER.JSON"
      echo "COMPOSER.JSON"
      echo "COMPOSER.JSON"
      echo "COMPOSER.JSON"
      echo "COMPOSER.JSON"

  if [ -f '.github/workflows/phpunit-summary-when-unrelated.yml' ]; then
    git diff --cached .github/workflows/phpunit-sqlite.yml | grep '^-' | grep phpunit
  fi

    echo ""
    echo "Update $FILE"
    echo "======================"
    gedit $FILE
    composer update php

    echo ""
    echo "Add file to git status"
    echo "======================"
    git add $FILE
    git add composer.lock
    CHANGED="1"
elif [ -f '.github/workflows/phpunit-summary-when-unrelated.yml' ]; then
    cp /home/nickv/Nextcloud/26/server/apps-action-templates/workflow-templates/dummycomposer.json composer.json

    echo ""
    echo "Add file to git status"
    echo "======================"
    git add $FILE
    CHANGED="1"
fi


FILE=".drone.yml"
  if [ -f '.drone.yml' ]; then
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

if [[ "$CHANGED" = "0" ]]; then
    echo "No testing"
    exit 1
fi

echo ""
echo "Commit branch"
echo "======================"
git commit -m "chore(CI): Update $DEFAULT_BRANCH php testing versions and workflow templates

Signed-off-by: Joas Schilling <coding@schilljs.com>"

echo ""
echo "Push branch"
echo "======================"
git push origin $BRANCH_NAME

echo ""
echo "Create PR"
echo "======================"
gh pr create --base $DEFAULT_BRANCH --fill >> ../../pr-list.txt

