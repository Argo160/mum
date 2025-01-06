#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    clear
    echo "You should run this script with root!"
    echo "Use sudo -i to change user to root"
    exit 1
fi
function mum-setup {
    clear
    cd
    read -p "Are you ready to setup the MUM-Bot? (y/n): " pp
    # Convert input to lowercase
    pp_lowercase=$(echo "$pp" | tr '[:upper:]' '[:lower:]')
    # Check if the input is "y"
    if [ "$pp_lowercase" = "y" ]; then
      cd
      mkdir mum-bot
      cd mum-bot
      read -p "Enter your telegram bot token: " tbt
      read -p "Enter your telegram user ID: " tui
      #Creating a Docker Compose File
      cat <<EOF > docker-compose.yml
services:
  mum-bot:
    container_name: mum-bot
    image: ares11430/mum-bot:latest
    network_mode: host
    restart: always
    volumes:
      - ./data:/app/data
EOF
      #Creating an Override File for Environment Variables
      cat <<EOF > docker-compose.override.yml
services:
  mum-bot:
    environment:
      TELEGRAM_MUM_TOKEN: $tbt
      TELEGRAM_MUM_MAIN_ADMIN_ID: $tui
      MUM_DB_HOST: 127.0.0.1
      MUM_DB_USER: <DATABASE_USERNAME>
      MUM_DB_PASSWORD: <DATABASE_PASSWORD>
      MUM_DB_NAME: marzban
      TZ: UTC
EOF

    
    fi
}
while true; do
clear
    echo "MUM-Bot SetUp"
    echo "Menu:"
    echo "1  - Install the Bot"
    echo "2  - View Logs"
    echo "3  - Restart The Bot"
    echo "4  - Stop The Bot"
    echo "5  - Exit"
    read -p "Enter your choice: " choice
    case $choice in
        1) mum-setup;;
        2) mum-logs;;
        3) mum-restart;;
        4) mum-stop;;
        5) echo "Exiting..."; exit;;
        *) echo "Invalid choice. Please enter a valid option.";;
    esac
done
    
