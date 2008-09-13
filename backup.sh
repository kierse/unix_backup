#!/bin/sh

#if ! [ -n "${1+a}" ] && [ -n "${2+a}" ] && [ -n "${3+a}" ]; then
if ! [ $# -ge 3 ] ; then
	echo "Usage: ./$0 <backup_dir> <server> <remote_backup_dir> [dow|day]"
	exit;
fi

# local directory to backup
LOCAL_DIR=$1

# server where backup data is stored
SERVER=$2

# remote directory on server where backup data should be stored
REMOTE_DIR=$3

# dow (day of week) or day incremental flag.  Using the 'dow' flag 
# will store incremental changes to data on remote server in a 
# directory based on the day of week (ie Monday, Tuesday, etc).  
# Using the 'day' flag will result in incremental data being 
# stored in a directory numbered according to the day of the 
# month (ie, 01, 02, 03, ...,30).

# name of incremental directory where changes to current backup
# data residing on remote server will be stored
if [ "$4" = "day" ]; then
	INCREMENTAL=`date +%d`
else
	INCREMENTAL=`date +%A`
fi

if [ "$SERVER" = "localhost" ]; then
	DESTINATION="$REMOTE_DIR"
else
	DESTINATION="$SERVER:$REMOTE_DIR"
fi

# default rsync backup options
OPTS="--archive --backup --backup-dir=$REMOTE_DIR/$INCREMENTAL/ --compress --delete --delete-excluded -F -v"

# the following lines clear the last weeks incremental data
# by synchronizing the remote directory with an empty one
[ -d $HOME/emptydir ] || mkdir $HOME/emptydir
rsync --archive --delete -v $HOME/emptydir/ $DESTINATION/$INCREMENTAL/
rmdir $HOME/emptydir

# sync home directory with newly emptied remote directory using
# above HOME_OPTS flags
rsync $OPTS $LOCAL_DIR/ $DESTINATION/current/

