<!DOCTYPE html>
<html lang="en">

<body>
<div class="container">
  <h1>📊 LogVault — Centralized Log Management System</h1>
  <p>
    LogVault is a <strong>centralized log management and monitoring system</strong> that simplifies log collection,
    monitoring, archiving, and reporting across multiple Linux servers. It provides a
    <strong>web-based dashboard</strong> to visualize security and login events, making it easy to detect suspicious activity.
  </p>

  <h2>🏗️ System Architecture</h2>
  <pre>
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
  </pre>

  <h2>⚙️ Features</h2>
  <ul>
    <li><strong>Centralized Log Collection</strong> – Secure SSH-based log retrieval from CentOS (<code>/var/log/secure</code>) and Ubuntu (<code>/var/log/auth.log</code>) servers.</li>
    <li><strong>Monitoring & Alerts</strong> – Detects failed or successful SSH logins. Raises alerts if login thresholds are exceeded.</li>
    <li><strong>Backup & Archiving</strong> – Daily logs are versioned and compressed into <code>.tar.gz</code> archives with Git history tracking.</li>
    <li><strong>Automated Scheduling</strong> – Fully automated with cron jobs for collection, monitoring, backup, and report generation.</li>
    <li><strong>Web Dashboard</strong> – An interactive <code>dashboard.html</code> generated with Bash, hosted via Apache.</li>
    <li><strong>Cross-Distribution Support</strong> – Works seamlessly with both <em>Ubuntu</em> and <em>CentOS/RHEL</em> environments.</li>
  </ul>

  <h2>🚀 Setup</h2>
  <h3>0. Environment</h3>
  <ul>
    <li><strong>1 central log aggregator VM</strong> → <code>logserver</code> (with Apache or httpd installed).</li>
    <li><strong>Multiple app VMs</strong> → <code>web01</code>, <code>web02</code>, <code>web03</code> (Ubuntu or CentOS).</li>
  </ul>

  <h3>1. Configure Networking & Hostnames</h3>
  <pre>
vim /etc/hosts            # Add entries for web01, web02, web03 with their corresponding private ip
ping -c 4 web01
ping -c 4 web02
ping -c 4 web03
  </pre>

  <h3>2. Configure SSH Access for Passwordless Login</h3>
  <pre>
ssh-keygen -t ed25519
ssh-copy-id vagrant@web01
ssh-copy-id vagrant@web02
ssh-copy-id vagrant@web03
  </pre>

  <h3>3. Run Scripts</h3>
  <p>Create project structure, scripts and configure permission</p>
  <pre>
mkdir -p ~/logvault/scripts ~/logvault/logs
chmod 744 collect_logs.sh monitor.sh backup.sh generate_report.sh
  </pre>
  <p>Collect logs:</p>
  <pre>./scripts/collect_logs.sh</pre>
  <p>Monitor logs:</p>
  <pre>./scripts/monitor.sh</pre>
  <p>Backup logs:</p>
  <pre>./scripts/backup.sh</pre>
  <p>Generate dashboard:</p>
  <pre>./scripts/generate_report.sh</pre>

  <h3>4. Initialize Git Repository</h3>
  <pre>
git init
git status
git add .
git status
git commit -m "Initial commit - setup LogVault"
  </pre>

  <h3>5. Install and Configure Apache WebServer</h3>
  <pre>
yum install -y httpd
systemctl start httpd
systemctl enable httpd
systemctl stop firewalld   # disabled firewall for testing
ip addr | grep inet        # get server IP to access dashboard
  </pre>

  <h3>6. Access Dashboard</h3>
  <pre>http://&lt;logserver-ip&gt;/dashboard.html</pre>

  <h2>⏰ Cron Job Automation</h2>
  <pre>
crontab -e
  </pre>
  <pre>

0 1 * * * /root/logvault/scripts/collect_logs.sh    # Collect logs daily at 1 AM

0 2 * * * /root/logvault/scripts/monitor.sh    # Monitor logs daily at 2 AM

0 3 * * * /root/logvault/scripts/backup.sh    # Backup logs daily at 3 AM

15 3 * * * /root/logvault/scripts/generate_report.sh     # Generate dashboard at 3:15 AM
  </pre>

  <h2>📂 Project Structure</h2>
  <pre>
logvault/
├── scripts/
│   ├── collect_logs.sh
│   ├── monitor.sh
│   ├── backup.sh
│   └── generate_report.sh
├── backups/          # Compressed & versioned log backups (.tar.gz)
  </pre>

  <h2>🌐 Dashboard Example</h2>
  <p>
    Once reports are generated, the web dashboard (e.g., <code>dashboard.html</code>) will display:
  </p>
  <ul>
    <li>Failed SSH login attempts</li>
    <li>Successful SSH logins</li>
    <li>Alerts for anomalies</li>
    <li>Historical log trends</li>
  </ul>

  <h2>🛡️ Security Considerations</h2>
  <ul>
    <li>Use SSH key authentication instead of passwords.</li>
    <li>Limit logserver access to trusted administrators.</li>
    <li>Ensure Apache is configured with best practices (firewall, SELinux/AppArmor, TLS if public-facing).</li>
  </ul>

  <footer>
    <p>📌 LogVault — Centralized Log Management | Built with Linux, Bash, Git, Apache</p>
  </footer>
</div>
</body>
</html>
