#!/bin/bash

LOG_DIR=~/logvault/logs
DATE=$(date +%F)

for HOST in $(ls $LOG_DIR)
do
	echo "Checking logs for $HOST..."

	if [[ -f $LOG_DIR/$HOST/secure-$DATE.log ]]
	then
		LOG_FILE="$LOG_DIR/$HOST/secure-$DATE.log"
	elif [[ -f $LOG_DIR/$HOST/auth-$DATE.log ]]
        then    
                LOG_FILE="$LOG_DIR/$HOST/auth-$DATE.log"
	else
		echo "No log file found for $HOST"
		continue
	fi

	FAILS=$(grep -i "Failed password" "$LOG_FILE" | wc -l)

	SUCCESS=$(grep -i "Accepted" "$LOG_FILE" | wc -l)

	echo "Failed SSH attempts: $FAILS"
	echo "Successful logs: $SUCCESS"

	if [ $FAILS -gt 5 ]
	then
		echo "ALERT: $HOST had $FAILS failed SSH logins today"
	fi
	echo
done
