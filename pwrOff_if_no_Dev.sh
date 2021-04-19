#!/bin/sh
# ----------------
# Function:
# This shell script shuts the NAS down on which it is running. 
# The shutdown is performed according a timing mechanism and only if no device is currently connected to the NAS.
# This script has to be started during Linux startup by a startup-script (e.g. for Synology-NAS with DSM 6 in /usr/syno/etc/rc.d/ )
# ----------------

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
# Absolute path of this script's folder
SCRIPTPATH=$(dirname "$SCRIPT")

#include config file
. $SCRIPTPATH/pwrOff_if_no_Dev_config.sh


LOGFILE=/tmp/autoshutdown.log   #logfile in RAM: No access to disk because of avoiding influence for energy options (disk sleep)

echo `date`" :  msg1: SCRIPT     = $SCRIPT" >> $LOGFILE
echo `date`" :  msg2: SCRIPTPATH = $SCRIPTPATH" >> $LOGFILE

waittime=600       #seconds (= 10')
maxErrorLoopsAtDaytime=60   #shows how often is a missing ping acceptable at daytime => shutdown after 10h (= waittime * maxErrorLoopsAtDaytime)
maxErrorLoopsAtEvening=6    #shows how often is a missing ping acceptable at evening => shutdown after  1h (= waittime * maxErrorLoopsAtEvening)
endOfDaytime=18    #Evening begins at 18h and ends at 24h (all other times are regarded as "Daytime")

scriptState="NO_DEV_AVAILABLE"
errorLoopCount=$maxErrorLoopsAtDaytime

while true; do
    if  [ `date +%H` -lt $endOfDaytime ]; then
        maxErrorLoops=$maxErrorLoopsAtDaytime  #Daytime: DS runs 10h without any device connected
    else
        maxErrorLoops=$maxErrorLoopsAtEvening  #Evening: DS runs  1h without any device connected
    fi

    for item in $DEVICE_IP_LIST; do
        ping -c 1 -W 5 "$item" > /dev/null      # "ping .. -W.." has been implemented because of improving usage with WLAN connections
        pingState=$?
        if [ $pingState == 0 ]; then
            break
        fi
    done

    if [ $scriptState == "NORMAL" ]; then
        errorLoopCount=$maxErrorLoops
        if [ $pingState == 1 ]; then
            scriptState="NO_DEV_AVAILABLE"
        fi
    elif [ $scriptState == "NO_DEV_AVAILABLE" ]; then
        if [ $pingState == 1 ]; then
            if [ $errorLoopCount -gt $maxErrorLoops ]; then
                errorLoopCount=$maxErrorLoops   #this corrects the transition from daytime to evening
            fi
            if [ $errorLoopCount -lt 1 ]; then
                # shutdown DS
                echo `date`" :  xxxx DS POWER OFF !!! xxxx" >> $LOGFILE
                sleep 60    #only for safety: Useraction still possible before poweroff
                poweroff
                #only for test case (otherwise following lines will never be executed)
                errorLoopCount=$maxErrorLoops
                scriptState="NORMAL"
            fi
            errorLoopCount=$(($errorLoopCount - 1))
            echo `date`" :  msg3: count down : $errorLoopCount" >> $LOGFILE

        else
            scriptState="NORMAL"
        fi
    fi
    echo `date`" :  msg4: scriptState = $scriptState; mEL = $maxErrorLoops" >> $LOGFILE
    sleep $waittime
done;
