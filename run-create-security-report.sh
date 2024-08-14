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
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m# ${dir##*/}\033[0m"
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m#\033[0m"
        ../script-create-security-report.sh $BRANCH 1
    else
        echo -e "\033[0;30mSkipping ${dir##*/}\033[0m"
    fi

    dir="server/3rdparty"
    if [[ "$SKIP_UNTIL" = "${dir##*/}" ]]; then
        STILL_SKIP="0"
    fi

    if [[ "$STILL_SKIP" = "0" ]]; then
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m# ${dir##*/}\033[0m"
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m#\033[0m"
        cd ${dir##*/}
        ../../script-create-security-report.sh $BRANCH 1
        cd ..
    else
        echo -e "\033[0;30mSkipping ${dir##*/}\033[0m"
    fi
cd ../

cd Branched/
for dir in ./*/
do
    dir=${dir%*/}
    if [[ "$SKIP_UNTIL" = "${dir##*/}" ]]; then
        STILL_SKIP="0"
    fi

    if [[ "${dir##*/}" = "files_rightclick" ]]; then
      if ! [[ "$BRANCH" = "stable26" ]]; then
        if ! [[ "$BRANCH" = "stable27" ]]; then
            # Only supported until 27
            continue
        fi
      fi
    fi

    if [[ "$STILL_SKIP" = "0" ]]; then
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m# ${dir##*/}\033[0m"
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m#\033[0m"
        cd ${dir##*/}
        ../../script-create-security-report.sh $BRANCH 0
        cd ..
    else
        echo -e "\033[0;30mSkipping ${dir##*/}\033[0m"
    fi
done
cd ../

cd Enterprise/
for dir in ./*/
do
    dir=${dir%*/}
    if [[ "$SKIP_UNTIL" = "${dir##*/}" ]]; then
        STILL_SKIP="0"
    fi

    if [[ "${dir##*/}" = "files_confidential" ]]; then
      # Only supported 26+
      if [[ "$BRANCH" = "stable25" ]]; then
            continue
      fi
    fi

    if [[ "$STILL_SKIP" = "0" ]]; then
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m# ${dir##*/}\033[0m"
        echo -e "\033[0;36m#\033[0m"
        echo -e "\033[0;36m#\033[0m"
        cd ${dir##*/}
        ../../script-create-security-report.sh $BRANCH 0
        cd ..
    else
        echo -e "\033[0;30mSkipping ${dir##*/}\033[0m"
    fi
done
cd ../

DATESTAMP=$(LANG=C date -u +'%b')
mv security-report.txt sec-$DATESTAMP-$BRANCH.txt

