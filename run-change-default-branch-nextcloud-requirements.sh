#!/bin/bash
#
# Steps:
# 1. Change `<nextcloud min-version="25" max-version="25" />`
# 2. In Branched/ and Stable/ bump the Minor version of the app: `<version>1.12.0</version>`

STILL_SKIP="0"
SKIP_UNTIL=$1

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
        echo ${dir##*/}
        cd ${dir##*/}
        ../../change-default-branch-nextcloud-requirements.sh
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
        echo ${dir##*/}
        cd ${dir##*/}
        ../../change-default-branch-nextcloud-requirements.sh
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
        echo ${dir##*/}
        cd ${dir##*/}
        ../../change-default-branch-nextcloud-requirements-multi.sh
        cd ..
    else
        echo "Skipping ${dir##*/}"
    fi
done
cd ../
