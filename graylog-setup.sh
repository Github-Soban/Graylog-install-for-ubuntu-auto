#!/bin/bash
set -e

## ---- System Preparation
echo "[1/8] Updating system and installing dependencies..."
apt update -y && apt upgrade -y
apt install apt-transport-https gnupg2 uuid-runtime pwgen curl dirmngr wget software-properties-common net-tools -y

## ---- Install OpenJDK
echo "[2/8] Installing OpenJDK 11..."
apt install openjdk-11-jre-headless -y

## ---- Install Elasticsearch
echo "[3/8] Installing Elasticsearch..."
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt update -y
apt install elasticsearch -y
sed -i 's/#cluster.name: .*/cluster.name: graylog/' /etc/elasticsearch/elasticsearch.yml
echo "action.auto_create_index: false" | tee -a /etc/elasticsearch/elasticsearch.yml
systemctl daemon-reload
systemctl enable --now elasticsearch

## ---- Install MongoDB
echo "[4/8] Installing MongoDB 6..."
curl -fsSL https://pgp.mongodb.com/server-6.0.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-server-6.0.gpg
echo "deb [ arch=amd64,arm64 signed=/etc/apt/trusted.gpg.d/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
apt update -y
apt install mongodb-org -y
systemctl enable --now mongod

## ---- Install Graylog
echo "[5/8] Installing Graylog..."
wget https://packages.graylog2.org/repo/packages/graylog-6.0-repository_latest.deb
dpkg -i graylog-6.0-repository_latest.deb
apt update -y
apt install graylog-server -y

SECRET=$(pwgen -N 1 -s 96)
ADMIN_PASS=$(echo -n 'admin123' | sha256sum | awk '{print $1}')

sed -i "s|^password_secret =.*|password_secret = $SECRET|" /etc/graylog/server/server.conf
sed -i "s|^root_password_sha2 =.*|root_password_sha2 = $ADMIN_PASS|" /etc/graylog/server/server.conf
sed -i "s|^http_bind_address =.*|http_bind_address = 0.0.0.0:9000|" /etc/graylog/server/server.conf
sed -i "s|^elasticsearch_hosts =.*|elasticsearch_hosts = http://127.0.0.1:9200|" /etc/graylog/server/server.conf
sed -i "s|^mongodb_uri =.*|mongodb_uri = mongodb://127.0.0.1:27017/graylog|" /etc/graylog/server/server.conf

systemctl daemon-reload
systemctl enable --now graylog-server

## ---- Nginx Reverse Proxy
echo "[6/8] Installing and configuring Nginx reverse proxy..."
apt install nginx -y
cat >/etc/nginx/sites-available/graylog.conf <<EOL
server {
    listen 80;
    server_name _;
    location / {
      proxy_pass http://127.0.0.1:9000;
      proxy_set_header Host \$http_host;
      proxy_set_header X-Forwarded-Host \$host;
      proxy_set_header X-Forwarded-Server \$host;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Graylog-Server-URL http://\$server_name/;
    }
}
EOL
ln -sf /etc/nginx/sites-available/graylog.conf /etc/nginx/sites-enabled/graylog.conf
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl restart nginx && systemctl enable nginx

## ---- Output Info and Finish
IP_ADDR=$(hostname -I | awk '{print $1}')
echo "=========================================================="
echo "Graylog setup complete!"
echo "Access the web UI at: http://$IP_ADDR/"
echo "Login: admin"
echo "Password: admin123"
echo "You can customize this script/config for production use."
echo "=========================================================="
