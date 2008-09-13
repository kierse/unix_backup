#!/bin/sh

SERVER=pissiphany.com

BACKUPPATH=$HOME/backup/elange

BACKUPDIR=`date +%A`

SHARE=/media/share/kierse

HOME_OPTS="--archive --backup --backup-dir=$BACKUPPATH/$HOME/$BACKUPDIR/ --compress --delete --delete-excluded -F -v"

SHARE_OPTS="--archive --backup --backup-dir=$BACKUPPATH/$SHARE/$BACKUPDIR/ --compress --delete --delete-excluded -F -v"

# backup home directory - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# the following line clears the last weeks incremental directory
[ -d $HOME/emptydir ] || mkdir $HOME/emptydir
rsync --archive --delete -v $HOME/emptydir/ $SERVER:$BACKUPPATH/$HOME/$BACKUPDIR/
rmdir $HOME/emptydir

rsync $HOME_OPTS $HOME/ $SERVER:$BACKUPPATH/$HOME/current/

# backup share directory- - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# the following line clears the last weeks incremental directory
[ -d $HOME/emptydir ] || mkdir $HOME/emptydir
rsync --archive --delete -v $HOME/emptydir/ $SERVER:$BACKUPPATH/$SHARE/$BACKUPDIR/
rmdir $HOME/emptydir

rsync $SHARE_OPTS $SHARE/ $SERVER:$BACKUPPATH/$SHARE/current/

