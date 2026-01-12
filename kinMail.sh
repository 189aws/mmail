#!/bin/bash

echo "[+] 安装必要组件..."
apt update
apt install -y curl wget

mkdir -p "/opt/email/mailstore"
mkdir -p "/opt/email/logs"

wget -qO /opt/email/server https://github.com/189aws/mmail/raw/refs/heads/main/server
wget -qO /opt/email/smtp https://github.com/189aws/mmail/raw/refs/heads/main/smtp

chmod +x /opt/email/smtp
chmod +x /opt/email/server

cat > /etc/systemd/system/simple_mail_smtp.service <<EOF
[Unit]
Description=Simple Mail SMTP
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/email
ExecStart=/opt/email/smtp
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/simple_mail_http.service <<EOF
[Unit]
Description=Simple Mail HTTP
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/email
ExecStart=/opt/email/server
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable simple_mail_http simple_mail_smtp
systemctl restart simple_mail_http simple_mail_smtp
