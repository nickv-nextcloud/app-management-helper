#!/bin/bash
#

SCRIPT_NAME=$1
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
        echo "#"
        echo "#"
        echo "# ${dir##*/}"
        echo "#"
        echo "#"
        cd ${dir##*/}
        ../../$SCRIPT_NAME.sh
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
        ../../$SCRIPT_NAME.sh
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
        ../../$SCRIPT_NAME.sh
        cd ..
    else
        echo "Skipping ${dir##*/}"
    fi
done
cd ../
