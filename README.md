📊 LogVault — Centralized Log Management System

📌 Overview

LogVault is a centralized log management and monitoring system built with Linux, Bash, Git, and Apache. It collects logs from multiple Linux servers (Ubuntu & CentOS), analyzes them for suspicious activity (e.g., failed SSH logins), archives them daily, and generates an HTML dashboard that is accessible via a web browser.

🏗️ Architecture
```
 ┌─────────────┐     ┌─────────────┐
 │   web01     │     │   web02     │
 │ (CentOS VM) │ ... │ (Ubuntu VM) │
 └──────┬──────┘     └──────┬──────┘
        │ SSH/Logs          │
        ▼                   ▼
     ┌──────────────────────────┐
     │        logserver         │
     │ (Central Aggregator VM) │
     │   - collect_logs.sh     │
     │   - monitor.sh          │
     │   - backup.sh           │
     │   - generate_report.sh  │
     └───────────┬─────────────┘
                 │
                 ▼
        ┌─────────────────┐
        │ Apache Webserver│
        │  /var/www/html  │
        └─────────────────┘
                 │
                 ▼
        🌐 Web Dashboard (dashboard.html)
```

⚙️ Features
	•	Log Collection: Securely fetches /var/log/secure (CentOS) or /var/log/auth.log (Ubuntu) from remote servers.
	•	Monitoring: Scans logs for failed/accepted SSH logins, raises alerts if thresholds are exceeded.
	•	Backup & Archiving: Compresses daily logs into .tar.gz and versions them with Git.
	•	Automation: Cron jobs handle collection, monitoring, backups, and report generation.
	•	Web Dashboard: Bash-generated HTML reports served from /var/www/html/dashboard.html.
	•	Cross-Distro Support: Handles both Ubuntu and CentOS log paths automatically.

 🚀 Setup

1. Environment
	•	1 central VM → logserver (with Apache or httpd installed depening on the os).
	•	Multiple app VMs → web01, web02, web03 (Ubuntu/CentOS).

2. Configure SSH Access

On logserver:
```
ssh-keygen -t ed25519
ssh-copy-id vagrant@web01
ssh-copy-id vagrant@web02
ssh-copy-id vagrant@web03
```

3. Run Scripts

Collect logs:
```
./scripts/collect_logs.sh
```

Monitor logs:
```
./scripts/monitor.sh
```

Backup logs:
```
./scripts/backup.sh
```

Generate dashboard:
```
./scripts/generate_report.sh
```

4. Access Dashboard

Open in browser:
```
http://<logserver-ip>/dashboard.html
```

⏰ Cron Automation

Add these to crontab -e on logserver:
```
# Collect logs daily at 1 AM
0 1 * * * /root/logvault/scripts/collect_logs.sh

# Monitor logs daily at 2 AM
0 2 * * * /root/logvault/scripts/monitor.sh

# Backup logs daily at 3 AM
0 3 * * * /root/logvault/scripts/backup.sh

# Generate dashboard at 3:15 AM
15 3 * * * /root/logvault/scripts/generate_report.sh
```
