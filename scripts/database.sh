#!/bin/bash

apt update && apt install -y unzip

# Install Fake Service
curl -LO https://github.com/nicholasjackson/fake-service/releases/download/v0.23.1/fake_service_linux_amd64.zip
unzip fake_service_linux_amd64.zip
mv fake-service /usr/local/bin
chmod +x /usr/local/bin/fake-service

# Fake Service Systemd Unit File
cat > /etc/systemd/system/database.service <<- EOF
[Unit]
Description=Database
After=syslog.target network.target
[Service]
Environment="MESSAGE='${DATABASE_MESSAGE}'"
Environment="NAME=${DATABASE_SERVICE_NAME}"
Environment="LISTEN_ADDR=0.0.0.0:27017"
ExecStart=/usr/local/bin/fake-service
ExecStop=/bin/sleep 5
Restart=always
[Install]
WantedBy=multi-user.target
EOF

# Reload unit files and start the database service
systemctl daemon-reload
systemctl start database