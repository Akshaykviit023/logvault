#!/bin/bash

SERVERS=("web01" "web02" "web03")
DATE=$(date +%F)

for HOST in "${SERVERS[@]}"; do
	echo "Collecting logs from $HOST ..."
	OS=$(ssh vagrant@$HOST 'source /etc/os-release && echo $ID')
	mkdir -p ~/logvault/logs/$HOST

	if [[ "$OS" == "ubuntu" ]]
	then
		echo "$HOST is $OS"
		ssh vagrant@$HOST "sudo cat /var/log/auth.log" > ~/logvault/logs/$HOST/auth-$DATE.log
		ssh vagrant@$HOST "sudo cat /var/log/syslog" > ~/logvault/logs/$HOST/syslog-$DATE.log
	elif [[ "$OS" == "centos" ]]
	then
		echo "$HOST is $OS"
		ssh vagrant@$HOST "sudo cat /var/log/secure" > ~/logvault/logs/$HOST/secure-$DATE.log
		ssh vagrant@$HOST "sudo cat /var/log/messages" > ~/logvault/logs/$HOST/messages-$DATE.log
	else
		echo "Unknown OS on $HOST (ID=$OS). Skipping..."
	fi
done

