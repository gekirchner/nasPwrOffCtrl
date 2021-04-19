15.04.21

This is only a test project for some tries with Git.

Project Name:   nasPwrOffCtrl

Language:       Bourne Shell

Function:       The shell script "pwrOff_if_no_Dev.sh" shuts the NAS down on which it is running. 
                The shutdown is performed according a timing mechanism and is only done if no device is currently connected to the NAS.
                The shell script uses a configuration file (pwrOff_if_no_Dev_config.sh) in which the necessary user settings are entered.
                The shell script has to be started during Linux startup by a start script (see below!)


Usage:          Copy the script pwrOff_if_no_Dev.sh into a folder of your NAS.
                Copy "pwrOff_if_no_Dev_config_example.sh" into the same folder of your NAS and rename it to "pwrOff_if_no_Dev_config.sh".
                Enter the settings of your environment in pwrOff_if_no_Dev_config.sh. This file serves now as your configuration file.
                The file S99autoshutdown_example.sh can be used as start script for the script pwrOff_if_no_Dev.sh.
                Make the *.sh files executable.
                The shutdown mechanism becomes active after the next power cycle of the NAS.

Remarks:        - Probably, root admissions are necessary for some handlings on the NAS (Be careful!!)
                - All devices which could be connected to the NAS should have a static IPv4 address
                - For Synology NAS, the file S99autoshutdown_example.sh has to be recreated in case of DSM upgrade.
                 

