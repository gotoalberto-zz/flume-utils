#!/bin/bash

#Script for clean service channels directories

#CONFIGURE DATA DIR, EXAMPLE:
#DATADIR="/var/datadirectory/"
DATADIR="/path/to/channels/temp/dir"

#DEFAULT user to start service. Example:
USERSERVICE="flume"

if [ "$1" != "" ]
then
        USERSERVICE="$1"
fi

find $DATADIR -maxdepth 1 -type d -print0 | while IFS= read -r -d '' dir
do
    CMD="sudo -u $USERSERVICE rm -rf $dir/data/*"
    eval $CMD
    CMD="sudo -u $USERSERVICE rm -rf $dir/checkpoint/*"
    eval $CMD
done
