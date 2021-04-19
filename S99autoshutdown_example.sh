#!/bin/sh                                                                       
#------------
# This script (S99autoshutdown_example.sh) is used as the start script for pwrOff_if_no_Dev.sh. 
# For Synology NAS with DSM 6, this script should be located in /usr/local/etc/rc.d.
# The SCRIPT_LOCATION has to be set with the full name of the folder in which pwrOff_if_no_Dev.sh exists. 
#
# For Synology NAS, the file S99autoshutdown_example.sh has to be recreated in case of DSM update.
#
#------------

#Adapt SCRIPT_LOCATION to your environment and uncomment it!
#SCRIPT_LOCATION=/my_volume/my_script_folder

case "$1" in                                                                      
        start)                                                                  
                echo "Starting autoshutdown script..."                          
                $SCRIPT_LOCATION/pwrOff_if_no_Dev.sh &                           
        ;;                                                                      
        stop)                                                                   
                killall pwrOff_if_no_PC.sh
                killall sleep                               
        ;;                                                                      
        restart)                                                                
                $0 stop                                                         
                sleep 1                                                         
                $0 start                                                        
        ;;                                                                      
esac
