#!/bin/bash

LOG_DIR=~/logvault/logs
REPORT_DIR=/var/www/html
DATE=$(date +%F)
REPORT_FILE=$REPORT_DIR/dashboard-$DATE.html
LATEST_REPORT=$REPORT_DIR/dashboard.html

mkdir -p $REPORT_DIR

cat > $REPORT_FILE <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>LogVault Dashboard - $DATE</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h1 { color: #333; }
    table { border-collapse: collapse; width: 80%; }
    th, td { border: 1px solid #aaa; padding: 8px; text-align: center; }
    th { background-color: #f2f2f2; }
    .alert { background-color: #ffcccc; }
  </style>
</head>
<body>
  <h1>LogVault Dashboard - $DATE</h1>
  <table>
    <tr><th>Server</th><th>Failed SSH Attempts</th><th>Successful Logins</th><th>Status</th></tr>
EOF

for HOST in $(ls $LOG_DIR)
do
	if [[ -f $LOG_DIR/$HOST/secure-$DATE.log ]]; then
        LOG_FILE="$LOG_DIR/$HOST/secure-$DATE.log"
    elif [[ -f $LOG_DIR/$HOST/auth-$DATE.log ]]; then
        LOG_FILE="$LOG_DIR/$HOST/auth-$DATE.log"
    else
        continue
    fi

    FAILS=$(grep -i "Failed password" "$LOG_FILE" | wc -l)
    SUCCESS=$(grep -i "Accepted" "$LOG_FILE" | wc -l)

    STATUS="OK"
    CLASS=""
    if [ $FAILS -gt 5 ]; then
        STATUS="ALERT"
        CLASS="class=\"alert\""
    fi

    echo "<tr $CLASS><td>$HOST</td><td>$FAILS</td><td>$SUCCESS</td><td>$STATUS</td></tr>" >> $REPORT_FILE
done

cat >> $REPORT_FILE <<EOF
</table>
</body>
</html>
EOF

cp $REPORT_FILE $LATEST_REPORT

echo "Reports generated:"
echo "   - $REPORT_FILE (archived)"
echo "   - $LATEST_REPORT (latest)"
