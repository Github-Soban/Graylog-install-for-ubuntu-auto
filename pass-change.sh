#!/bin/bash

read -sp "Enter new Graylog admin password: " NEW_PASS
echo

# Generate password secret and hash
NEW_SECRET=$(pwgen -N 1 -s 96)
NEW_PASS_HASH=$(echo -n "$NEW_PASS" | sha256sum | cut -d " " -f 1)

# Backup current config
cp /etc/graylog/server/server.conf /etc/graylog/server/server.conf.bak

# Update config file
sudo sed -i "s|^password_secret =.*|password_secret = $NEW_SECRET|" /etc/graylog/server/server.conf
sudo sed -i "s|^root_password_sha2 =.*|root_password_sha2 = $NEW_PASS_HASH|" /etc/graylog/server/server.conf

# Restart Graylog service
sudo systemctl restart graylog-server

echo "Graylog admin password changed successfully."
