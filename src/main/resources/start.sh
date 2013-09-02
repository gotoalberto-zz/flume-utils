#!/bin/bash

#Script for include on *.conf directory.
#Launch a service and manage the pid an log.
#Place this script on *.conf file directory.

#DEFAULT user to start service. Example:
USERSERVICE="flume"
#Flume-ng bin file path
FLUMEPATH="/path/to/flume-ng"
#Agent name
AGENTNAME="agent"

if [ "$1" == "" ]
then
        echo "usage: sudo ./start.sh (SERVICENAME) (OPTIONAL: USERNAME)"
        exit
fi

if [ "$2" != "" ] 
then
        USERSERVICE="$2"
fi

SERVICENAME="$1"
INSTALLPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FILECONF="$INSTALLPATH/$SERVICENAME.conf"
if [ ! -f "$FILECONF" ]
then
        echo "File $SERVICENAME.conf does not exist."
        exit
fi

PIDFILE="$INSTALLPATH/pid/$SERVICENAME.pid"
if [ -f $PIDFILE ]
then
        echo "The service is already running!"
else
        LOGFILE="$INSTALLPATH/log/$SERVICENAME.log"
        if [ -f $LOGFILE ]
        then
                CMD="sudo -u $USERSERVICE rm -f $LOGFILE"
                eval $CMD
        fi

        PIDFOLDER="$INSTALLPATH/pid"
        if [ ! -d $PIDFOLDER ]
        then
                CMD="sudo -u $USERSERVICE mkdir $PIDFOLDER"
                eval $CMD
        fi

        LOGFOLDER="$INSTALLPATH/log"
        if [ ! -d $LOGFOLDER ]
        then
                CMD="sudo -u $USERSERVICE mkdir $LOGFOLDER"
                eval $CMD
        fi

        CMD="sudo -u $USERSERVICE $FLUMEPATH $AGENTNAME -n agent -f $INSTALLPATH/$SERVICENAME.conf -c $INSTALLPATH/conf &> $INSTALLPATH/log/$SERVICENAME.log &"
        eval $CMD
        PID=$!
        CMD="sudo -u $USERSERVICE echo \"$PID\" > $INSTALLPATH/pid/$SERVICENAME.pid"
        eval $CMD
        CMD="sudo -u $USERSERVICE echo \"$USERSERVICE\" > $INSTALLPATH/pid/$SERVICENAME.user"
        eval $CMD
        echo "$SERVICENAME started!"
fi
