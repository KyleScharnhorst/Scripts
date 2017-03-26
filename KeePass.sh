#!/bin/sh

ACTION=$1
COPY_ACTION=copy
RUN_ACTION=run
MAIN_KEE_PASS_PATH=/r/KeePass
KEE_PASS_EXE_PATH=$MAIN_KEE_PASS_PATH/keepass.exe
PORTABLE_KEY_PASS_DIR=/t/portableApps/KeePass
COPY_BACKUP_FILE=backup.tar
COPY_BACKUP_FILE_PATH=$PORTABLE_KEY_PASS_DIR/$COPY_BACKUP_FILE

function print_usage () {
	echo Usage: $0 \<$RUN_ACTION\|$COPY_ACTION\>
	echo run: runs main KeePass.
	echo copy: copies main KeePass to portable KeePass location \(creates portable KeePass backup\).
	echo Example: $0 $RUN_ACTION
	echo Example: $0 $COPY_ACTION
	exit 1
}

if [ "$#" -ne 1 ]; then
	print_usage
fi

if [ "$1" == "$RUN_ACTION" ]; then
	if [ ! -f $KEE_PASS_EXE_PATH ]; then
		echo KeePass not found.
		exit 1
	fi
	echo Running KeePass on external HDD.
	$KEE_PASS_EXE_PATH > /dev/null 2>&1 &
elif [ "$1" == "$COPY_ACTION" ]; then
	if [ ! -d $PORTABLE_KEY_PASS_DIR ]; then
		echo Portable KeePass location not found.
	fi

	if [ -f $COPY_BACKUP_FILE_PATH ]; then
		echo Found previous backup. Removing.
		rm -f $COPY_BACKUP_FILE_PATH
	fi

	echo Backing up Portable KeePass.
	tar -cf $COPY_BACKUP_FILE_PATH $PORTABLE_KEY_PASS_DIR/*

	echo Copying main KeePass to portable location.
	cp -v --update --recursive $MAIN_KEE_PASS_PATH/* $PORTABLE_KEY_PASS_DIR
else
	echo Action: "$1" not recognized.
	print_usage
fi

