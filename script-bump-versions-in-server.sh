#!/bin/bash
#
# Checkout and update the branch on all repos

SERVER_DIR=$1
SERVER_VERSION=$2

for dir in $SERVER_DIR/apps/*/
do
    dir=${dir%*/}
    php bump-version.php $dir $SERVER_VERSION
done

