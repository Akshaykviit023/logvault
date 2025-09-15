#!/bin/bash

BACKUP_DIR=~/logvault/backups
DATE=$(date +%F)

mkdir -p $BACKUP_DIR

tar -czf $BACKUP_DIR/logs-$DATE.tar.gz -C ~/logvault/logs .

cd ~/logvault
git add backups/
git commit -m "Bckup for $DATE"

