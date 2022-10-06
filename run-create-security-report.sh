#!/bin/bash
#

STILL_SKIP="0"
BRANCH=$1


if ! [[ "$BRANCH" ]]; then
    echo "Missing target branch"
    exit 1
fi


SKIP_UNTIL=$2

if [[ "$SKIP_UNTIL" ]]; then
    STILL_SKIP="1"
else
    echo "" >> ./security-report.txt
    echo "# $BRANCH" >> ./security-report.txt
    echo "" >> ./security-report.txt
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
        ../../script-create-security-report.sh $BRANCH
        cd ..
    else
        echo "Skipping ${dir##*/}"
    fi
done
cd ../

