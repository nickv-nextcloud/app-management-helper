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
    echo "" > ./security-report.txt
    echo "# $BRANCH" >> ./security-report.txt
    echo "" >> ./security-report.txt
fi

cd server/
    dir="server"
    if [[ "$SKIP_UNTIL" = "${dir##*/}" ]]; then
        STILL_SKIP="0"
    fi

    if [[ "$STILL_SKIP" = "0" ]]; then
        echo "#"
        echo "#"
        echo "# ${dir##*/}"
        echo "#"
        echo "#"
        ../script-create-security-report.sh $BRANCH
    else
        echo "Skipping ${dir##*/}"
    fi

    dir="server/3rdparty"
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
cd ../

cd Branched/
for dir in ./*/
do
    dir=${dir%*/}
    if [[ "$SKIP_UNTIL" = "${dir##*/}" ]]; then
        STILL_SKIP="0"
    fi

    if [[ "${dir##*/}" = "files_videoplayer" ]]; then
      if ! [[ "$BRANCH" = "stable23" ]]; then
        if ! [[ "$BRANCH" = "stable24" ]]; then
            continue
        fi
      fi
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

DATESTAMP=$(date -u +'%Y-%b')
mv security-report.txt security-report-$BRANCH-$DATESTAMP.txt

