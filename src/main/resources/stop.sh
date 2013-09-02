#!/bin/bash

#Script for stop a Flume agent.
#Place this script on *.conf file directory.

if [ "$1" == "" ]
then
        echo "usage: sudo ./stop.sh (SERVICENAME)"
        exit
fi

SERVICENAME="$1"
INSTALLPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FILECONF="$INSTALLPATH/$SERVICENAME.conf"
if [ ! -f $FILECONF ]
then
        echo "File $SERVICENAME.conf does not exist."
        exit
fi

CMD="cat $INSTALLPATH/pid/$SERVICENAME.user"
USERSERVICE=$(eval $CMD)

PIDFILE="$INSTALLPATH/pid/$SERVICENAME.pid"
if [ -f $PIDFILE  ]
then
        CMD="sudo -u $USERSERVICE cat $INSTALLPATH/pid/$SERVICENAME.pid"
        PARENTPID=$(eval $CMD)
        CMD="sudo -u $USERSERVICE ps --no-headers -o pid --ppid=$PARENTPID |tee  $INSTALLPATH/pid/$SERVICENAME.pids"
        eval $CMD
        CMD="sudo -u $USERSERVICE cat $INSTALLPATH/pid/$SERVICENAME.pids | wc -l | tr -d ' '"
        LINES=$(eval $CMD)

        LINE="1"
        while [ "$LINE" -le "$LINES" ]
        do
                CMD="sudo -u $USERSERVICE sed '$LINE q;d' $INSTALLPATH/pid/$SERVICENAME.pids"
                LINECONTENT=$(eval $CMD)
                CMD="sudo kill -9 $LINECONTENT"
                eval $CMD
                ((LINE++))
        done
        CMD="sudo kill -9 $PARENTPID"
        eval $CMD

        CMD="sudo -u $USERSERVICE rm -f $INSTALLPATH/pid/$SERVICENAME.pids $INSTALLPATH/pid/$SERVICENAME.user $PIDFILE"
        eval $CMD

        echo "$SERVICENAME stopped!"
else
        echo "$SERVICENAME is not started."
fi
