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

