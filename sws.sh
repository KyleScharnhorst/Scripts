#!/usr/bin/env bash

# Get script's directory to place headphone file.
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
#################################

# Declare headphone file
HEADPHONE_FILE=$DIR/.headphone

# If file exists, set speakers, else set headphones.
if [ -e $HEADPHONE_FILE ]
then
	rm $HEADPHONE_FILE
	nircmdc.exe setdefaultsounddevice "6 - VW246" 1
else
	touch $HEADPHONE_FILE
	nircmdc.exe setdefaultsounddevice "Headset Earphone" 1
fi
