#!/bin/bash
#
# Steps:
# 1. Add "stable24" to all testing matrixes as server versions that contain "master"
# 2. If an "include" or "exclude" rule exists for "master" copy that for "stable24"

BRANCH=$1

if ! [[ "$BRANCH" ]]; then
    echo "Missing target branch"
    exit 1
fi

STILL_SKIP="0"
SKIP_UNTIL=$2

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
        ../../change-stable-testing-targets.sh $BRANCH
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
        ../../create-stable-branch.sh $BRANCH
        ../../change-stable-testing-targets.sh $BRANCH
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
        DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
        ../../change-stable-testing-targets.sh $DEFAULT_BRANCH
        cd ..
    else
        echo "Skipping ${dir##*/}"
    fi
done
cd ../
