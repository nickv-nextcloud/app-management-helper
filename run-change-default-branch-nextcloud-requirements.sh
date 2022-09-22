#!/bin/bash
#
# Steps:
# 1. Change `<nextcloud min-version="25" max-version="25" />`
# 2. In Branched/ and Stable/ bump the Minor version of the app: `<version>1.12.0</version>`

STILL_SKIP="0"
NEW_VERSION=$1
SKIP_UNTIL=$2


if ! [[ "$NEW_VERSION" ]]; then
    echo "Missing nextcloud version"
    exit
fi

if [[ "$SKIP_UNTIL" ]]; then
    STILL_SKIP="1"
fi

cd Branched/
for dir in ./*/
do
    dir=${dir%*/}
    if [[ "$SKIP_UNTIL" = "${dir##*/}" ]]; then
        STILL_SKIP="0"
    fi

    if [[ "$STILL_SKIP" = "0" ]]; then
        echo "#"
        echo "#"
        echo "# ${dir##*/}"
        echo "#"
        echo "#"
        cd ${dir##*/}
        ../../change-default-branch-nextcloud-requirements.sh $NEW_VERSION
        cd ..
    else
        echo "Skipping ${dir##*/}"
    fi
done
cd ../

cd Stable/
for dir in ./*/
do
    dir=${dir%*/}
    if [[ "$SKIP_UNTIL" = "${dir##*/}" ]]; then
        STILL_SKIP="0"
    fi

    if [[ "$STILL_SKIP" = "0" ]]; then
        echo "#"
        echo "#"
        echo "# ${dir##*/}"
        echo "#"
        echo "#"
        cd ${dir##*/}
        ../../change-default-branch-nextcloud-requirements.sh $NEW_VERSION
        cd ..
    else
        echo "Skipping ${dir##*/}"
    fi
done
cd ../

cd Multibranch/
for dir in ./*/
do
    dir=${dir%*/}
    if [[ "$SKIP_UNTIL" = "${dir##*/}" ]]; then
        STILL_SKIP="0"
    fi

    if [[ "$STILL_SKIP" = "0" ]]; then
        echo "#"
        echo "#"
        echo "# ${dir##*/}"
        echo "#"
        echo "#"
        cd ${dir##*/}
        ../../change-default-branch-nextcloud-requirements-multi.sh $NEW_VERSION
        cd ..
    else
        echo "Skipping ${dir##*/}"
    fi
done
cd ../
