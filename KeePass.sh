#!/bin/sh

ACTION=$1
COPY_ACTION=copy
RUN_ACTION=run
EJECT_ACTION=eject
MAIN_KEE_PASS_PATH=/r/KeePass
KEE_PASS_EXE_PATH=$MAIN_KEE_PASS_PATH/keepass.exe
PORTABLE_DRIVE_LETTER=t
PORTABLE_KEY_PASS_DIR=/$PORTABLE_DRIVE_LETTER/portableApps/KeePass
COPY_BACKUP_FILE=backup.tar
COPY_BACKUP_FILE_PATH=$PORTABLE_KEY_PASS_DIR/$COPY_BACKUP_FILE
SCRIPT_LOC=$(dirname $0)

function print_usage () {
	echo Usage: $0 \<$RUN_ACTION\|$COPY_ACTION\|$EJECT_ACTION\>
	echo $RUN_ACTION: runs main KeePass.
	echo $COPY_ACTION: copies main KeePass to portable KeePass location \(creates portable KeePass backup\).
	echo $EJECT_ACTION: ejects the portable KeePass location.
	echo Example: $0 $RUN_ACTION
	echo Example: $0 $COPY_ACTION
	echo Example: $0 $EJECT_ACTION
	exit 1
}

function check_portable_loc () {
	if [ ! -d $PORTABLE_KEY_PASS_DIR ]; then
		echo Portable KeePass location not found.
		exit 1
	fi
}

if [ "$#" -ne 1 ]; then
	print_usage
fi

if [ "$1" == "$RUN_ACTION" ]; then
	if [ ! -f $KEE_PASS_EXE_PATH ]; then
		echo KeePass not found at: $KEE_PASS_EXE_PATH
		exit 1
	fi
	echo Running KeePass on external HDD.
	$KEE_PASS_EXE_PATH > /dev/null 2>&1 &
elif [ "$1" == "$COPY_ACTION" ]; then
	check_portable_loc

	if [ -f $COPY_BACKUP_FILE_PATH ]; then
		echo Found previous backup. Removing.
		rm -f $COPY_BACKUP_FILE_PATH
	fi

	echo Backing up Portable KeePass.
	tar -cf $COPY_BACKUP_FILE_PATH $PORTABLE_KEY_PASS_DIR/*

	echo Copying main KeePass to portable location.
	cp -v --update --recursive $MAIN_KEE_PASS_PATH/* $PORTABLE_KEY_PASS_DIR
elif [ "$1" == "$EJECT_ACTION" ]; then
	check_portable_loc
    echo Attempting to eject portable drive...
	$SCRIPT_LOC/RemoveDrive.exe $PORTABLE_DRIVE_LETTER: -l
    echo Ensuring drive was ejected...
    check_portable_loc
else
	echo Action: "$1" not recognized.
	print_usage
fi

