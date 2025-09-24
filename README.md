# Graylog-install-for-ubuntu-auto
install graylog fully automated one click install and easy to step but only for linux mainly fouse on deb and ubuntu but you could use this for also for other linux and contribute more

graylog-automation-setup/
│

├── README.md

├── install_graylog.sh

└── configs/
    ├── nginx-graylog.conf
    ├── rsyslog-client.conf
    └── nxlog.conf.example


# Graylog Automated Installation

This repository contains a Bash script to automate the installation and setup of **Graylog**, **Elasticsearch**, **MongoDB**, and **Nginx** on Ubuntu.

## Installation

Clone the repository and run the installer:



git clone https://github.com/your-username/graylog-automation-setup.git

cd graylog-automation-setup

chmod +x install_graylog.sh

sudo ./install_graylog.sh




## Features
- Installs OpenJDK, Elasticsearch, MongoDB, Graylog
- Configures Graylog with password and secret keys
- Adds Nginx as a reverse proxy
- Provides example configs for Ubuntu and Windows clients





Instructions:

    Save as graylog-setup.sh

    chmod +x graylog-setup.sh

    sudo ./graylog-setup.sh



Running Graylog on LAN

To make Graylog accessible to other machines on your local network, always set:

  http_bind_address = 0.0.0.0:9000 in /etc/graylog/server/server.conf

   Nginx should proxy_pass to http://127.0.0.1:9000 and listen on 0.0.0.0:80 (done by default in the script).

 Ensure firewall rules allow inbound traffic on HTTP (80) and/or HTTPS (443) ports from your LAN.

 Share the server’s LAN IP for web access (e.g., http://192.168.1.10/). Clients can point their syslog or beats agents to this LAN IP.

Running Graylog on Localhost-Only

 Default config (http_bind_address = 127.0.0.1:9000) restricts access to the local machine only.

 Nginx should still proxy to localhost and only allow local traffic. Optionally remove Nginx, and access Graylog directly at http://localhost:9000/.

 Ideal for test/dev or single-user environments.

Additional Advanced Options

  Use HTTPS for secure log and web access. Add SSL certs to Nginx and configure server block to use listen 443 ssl and relevant certificate paths.

Multi-node & high-availability: Deploy Elasticsearch and Graylog in cluster mode for resilience.

Docker and Compose: Consider containerizing the stack. Expose ports and networks in docker-compose.yml for LAN or private use.

 Input tuning: System > Inputs in the Graylog UI lets users define which protocols and ports to listen on (TCP, UDP, Beats).

   Security: Harden MongoDB and Elasticsearch network settings, disable remote admin, and use network firewalls.

Key Configuration Differences
Scenario	Primary Setting	Firewall Requirement


LAN	http_bind_address = 0.0.0.0:9000	Open HTTP/HTTPS to network
Localhost	http_bind_address = 127.0.0.1:9000	None (default permit)

Both use the same basic script; only adjust the parameters for network accessibility and service binding as required for your environment.




How to Use This Script

    Save the above as graylog-runner.sh
    

    Make it executable: chmod +x graylog-runner.sh


    Run it as a user with sudo privileges: ./graylog-runner.sh


    Use the menu to start, stop, restart, or check the status of all services easily.


