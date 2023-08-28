#!/bin/bash

CONFIG_FILE="/root/tuic/config.json"
# Get public IPs
IPV4=$(curl -s https://v4.ident.me)
if [ $? -ne 0 ]; then
    echo "Error: Failed to get IPv4 address"
    return
fi

IPV6=$(curl -s https://v6.ident.me)
if [ $? -ne 0 ]; then
    echo "Error: Failed to get IPv6 address"
    return
fi
PORT=$(jq -r '.server' "/root/tuic/config.json" | awk -F '[][]' '{print $3}' | cut -d ':' -f 2)
CONGESTION_CONTROL=$(jq -r ".congestion_control" /root/tuic/config.json)
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print characters with delay
print_with_delay() {
    text="$1"
    delay="$2"
    for ((i = 0; i < ${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo
}

# Function to add a new user to config.json
add_user_to_config() {
    local uuid=$(uuidgen)
    read -p "Enter a password for the new user: " password
    jq ".users += {\"$uuid\":\"$password\"}" $CONFIG_FILE >temp.json && mv temp.json $CONFIG_FILE
    echo -e "${GREEN}New user added with UUID: $uuid${NC}"
    print_config_url $uuid $password
    systemctl restart tuic
}

# Function to list all users from config.json
list_users() {
    echo -e "${YELLOW}List of Users:${NC}"
    jq -r '.users | to_entries[] | "UUID: \(.key) \t Password: \(.value)"' $CONFIG_FILE
}

# Function to delete a user from config.json
delete_user_from_config() {
    list_users
    read -p "Enter the UUID of the user you want to delete: " uuid
    uuid="\"$uuid\""
    user_exists=$(jq ".users.$uuid" "$CONFIG_FILE")

    if [ "$user_exists" != "null" ]; then
        jq "del(.users.$uuid)" "$CONFIG_FILE" >temp.json && mv temp.json "$CONFIG_FILE"
        echo -e "${GREEN}User with UUID $uuid has been deleted.${NC}"
        systemctl restart tuic
    else
        echo -e "${RED}User with UUID $uuid not found.${NC}"
    fi
}

print_config_url() {
    UUID=$1
    PASSWORD=$2
    IPV4_URL="tuic://$UUID:$PASSWORD@$IPV4:$PORT/?congestion_control=$CONGESTION_CONTROL&udp_relay_mode=native&alpn=h3%2Cspdy%2F3.1&allow_insecure=1"
    echo $IPV4_URL
    IPV6_URL="tuic://$UUID:$PASSWORD@[$IPV6]:$PORT/?congestion_control=$CONGESTION_CONTROL&udp_relay_mode=native&alpn=h3%2Cspdy%2F3.1&allow_insecure=1"
    echo $IPV6_URL
}
get_config_url() {
    list_users
    read -p "Enter the UUID of the user you want to get : " uuid
    search_uuid=\"$uuid\"
    password=$(jq -r ".users.$search_uuid" "$CONFIG_FILE")
    if [ "$password" != "null" ]; then
        print_config_url $uuid $password
    else
        echo -e "${RED}User with UUID $uuid not found.${NC}"
    fi

}

# Main menu
while true; do
    clear
    echo -e "${GREEN}tuic Service Management${NC}"
    echo "1) Service Status"
    echo "2) Restart Service "
    echo "3) Add New User"
    echo "4) List All Users"
    echo "5) Delete User"
    echo "6) Get config url"
    echo "7) Exit"
    read -p "Enter your choice: " choice

    case $choice in
    1)
        systemctl status tuic
        read -p "Press Enter to continue..."
        ;;
    2)
        systemctl restart tuic
        read -p "Press Enter to continue..."
        ;;
    3)
        add_user_to_config
        read -p "Press Enter to continue..."
        ;;
    4)
        list_users
        read -p "Press Enter to continue..."
        ;;
    5)
        delete_user_from_config
        read -p "Press Enter to continue..."
        ;;
    6)
        get_config_url
        read -p "Press Enter to continue..."
        ;;
    7)
        echo -e "${GREEN}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice. Please select a valid option.${NC}"
        read -p "Press Enter to continue..."
        ;;
    esac
done
