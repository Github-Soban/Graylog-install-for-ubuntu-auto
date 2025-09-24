#!/bin/bash

# Service names
SERVICES=("elasticsearch" "mongod" "graylog-server" "nginx")

function print_menu() {
    echo "----------------------------------------"
    echo " Graylog Service Manager"
    echo "----------------------------------------"
    echo "1) Start all services"
    echo "2) Stop all services"
    echo "3) Restart Graylog server"
    echo "4) Check all services status"
    echo "5) Exit"
    echo "----------------------------------------"
    echo -n "Choose an option [1-5]: "
}

function start_all() {
    echo "Starting all services..."
    for service in "${SERVICES[@]}"; do
        sudo systemctl start $service
        echo "Started $service"
    done
}

function stop_all() {
    echo "Stopping all services..."
    for service in "${SERVICES[@]}"; do
        sudo systemctl stop $service
        echo "Stopped $service"
    done
}

function restart_graylog() {
    echo "Restarting Graylog server..."
    sudo systemctl restart graylog-server
    echo "Graylog server restarted"
}

function status_all() {
    echo "Checking status of all services..."
    for service in "${SERVICES[@]}"; do
        echo "Status of $service:"
        sudo systemctl status $service --no-pager | head -20
        echo "----------------------------------------"
    done
}

# Run menu in a loop
while true; do
    print_menu
    read -r choice
    case $choice in
        1) start_all ;;
        2) stop_all ;;
        3) restart_graylog ;;
        4) status_all ;;
        5) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option, please select 1-5." ;;
    esac
    echo ""
    echo "Press Enter to continue..."
    read
done
