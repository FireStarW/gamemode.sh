#!/bin/bash
# set power scaling and disable services
SCRIPTNAME="${0##*/}"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root, use sudo "$SCRIPTNAME" instead" 1>&2
   exit 1
fi

if [ "$1" != "" ]; then
	#on
	if [ "$1" = "on" ]; then
		cpufreq-set -g performance
		nvidia-settings -a [gpu:0]/GPUPowerMizerMode=1 #> /dev/null
	#	systemctl stop mysql.service 
		systemctl stop apport.service 
		systemctl stop whoopsie.service
		systemctl stop speech-dispatcher.service 
		echo "- - - - - Gamemode on - - - - -"
	
	#off
	elif [ "$1" = "off" ]; then
		cpufreq-set -g powersave
		nvidia-settings -a [gpu:0]/GPUPowerMizerMode=0 
		systemctl start apport.service 
		echo "- - - - - Gamemode off - - - - -"

	else
		echo "USAGE:" 
		echo "$SCRIPTNAME {on|off}"
	fi
else
	echo "USAGE:" 
	echo "$SCRIPTNAME {on|off}"
fi

