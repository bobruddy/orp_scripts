#!/bin/bash

DIALOG_TITLE="OpenRepeater $ORP_VERSION Setup"

################################################################################
# FILE SYSTEM RESIZE MESSAGE
################################################################################

function menu_expand_file_system {
	MESSAGE="WE'VE ENCOUNTERED A PROBLEM: Either you forgot to expand your file system or your card/disk is not large enough. OpenRepeater requires a card/disk of at least $1 or greater.\n\nYou may run this script again one you have expanded your file system and rebooted your system.\n\nNOTE FOR RASPBERRY PI USERS: You may choose the 'raspi-config' option to expand your file system. You can find the expand file system function under the 'Advanced' menu."
	
	if (whiptail --title "$DIALOG_TITLE" --yes-button "Abort & Fix Manually" --no-button "Run Raspi-Config"  --yesno "$MESSAGE" 15 120) then
	    echo "You must now expand your file system before you can proceed."; exit;
	else
	    raspi-config;
	fi
}


################################################################################
# WELCOME MESSAGE
################################################################################

function menu_welcome_message {
	WELCOME_MESSAGE="WELCOME TO OPENREPEATER\n\nThis script is meant to be run on a fresh install of Debian $REQUIRED_OS_VER ($REQUIRED_OS_NAME)\n\nTHIS SCRIPT IS NOT INTENDED TO BE RUN MORE THAN ONCE"
	
	whiptail --title "$DIALOG_TITLE" --msgbox "$WELCOME_MESSAGE" 15 60
}


################################################################################
# BUILD TYPE MENU
################################################################################

function menu_build_type {
	OPTION=$(whiptail --title "$DIALOG_TITLE" --menu "Choose the type of build you wish to perform" 15 60 4 \
	"1" "Full OpenRepeater Build (Recommended)" \
	"2" "SVXLink ONLY Build (Advanced)"  3>&1 1>&2 2>&3)
	 
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
		case $OPTION in
			1) INPUT_INSTALL_TYPE="ORP";;
			2) INPUT_INSTALL_TYPE="SVXLink";;
		esac
	else
	    exit;
	fi
}


################################################################################
# HOSTNAME MENU
################################################################################

function menu_hostname {
	HOSTNAME=$(whiptail --title "$DIALOG_TITLE" --inputbox "Please choose a hostname. Press <ENTER> to accept default." 10 60 openrepeater 3>&1 1>&2 2>&3)
	 
	exitstatus=$?
	if [ $exitstatus = 1 ]; then
	    exit;
	fi
}


################################################################################
# END MESSAGE
################################################################################

function menu_end_message {
	END_MESSAGE="The OpenRepeater install is now complete and your system is ready for use. Please go to https://$IP_ADDRESS in your browser and configure your OpenRepeater setup.\n\nNOTE: You may receive a security warning from your web browser. This is normal as the SSL certificate is self-signed.\n\nDON'T FORGET TO REBOOT FIRST!!!\n\n$1"
	
	if (whiptail --title "$DIALOG_TITLE" --yes-button "REBOOT NOW" --no-button "Cancel"  --yesno "$END_MESSAGE" 18 60) then
	    echo "REBOOTING NOW"; reboot;
	else
	    echo "Don't forget to reboot..."; exit;
	fi
}
