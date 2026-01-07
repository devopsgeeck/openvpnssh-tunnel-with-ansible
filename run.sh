#!/usr/bin/env bash
set -e

# ===== Colors =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# ===== UI Helpers =====
LINE="${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

info()  { echo -e "${BLUE}ℹ️  $1${NC}"; }
ok()    { echo -e "${GREEN}✔ $1${NC}"; }
warn()  { echo -e "${YELLOW}⚠ $1${NC}"; }
err()   { echo -e "${RED}✖ $1${NC}"; }

HOST_FILE="host.ini"

# ===== Check Ansible =====
echo -e "\n$LINE"
echo -e "${BOLD}${YELLOW}🔍 Checking Ansible installation...${NC}"
echo -e "$LINE\n"

if ! command -v ansible-playbook >/dev/null 2>&1; then
	info "Ansible not found. Installing using pip3..."

	if ! command -v pip3 >/dev/null 2>&1; then
		err "pip3 not found. Please install python3-pip first"
		exit 1
	fi

	pip3 install --user ansible

	if ! command -v ansible-playbook >/dev/null 2>&1; then
		err "Ansible is not installed"
		exit 1
	fi
elif command -v ansible-playbook >/dev/null 2>&1; then
	ok "Ansible successfully installed"
	sleep 2
	clear

fi

# ===== User Input =====
echo -e "\n$LINE"
echo -e "${BOLD}${CYAN}🖥️  Server configuration${NC}"
echo -e "$LINE\n"

read -p "$(echo -e "${YELLOW}➜ Server1 IP              : ${NC}")" SERVER1_IP
read -p "$(echo -e "${YELLOW}➜ Server1 SSH Port        : ${NC}")" SERVER1_PORT
read -p "$(echo -e "${YELLOW}➜ SSH User                : ${NC}")" USER
read -p "$(echo -e "${YELLOW}➜ Server2 IP              : ${NC}")" SERVER2_IP
read -p "$(echo -e "${YELLOW}➜ Server2 SSH Port        : ${NC}")" SERVER2_PORT
read -s -p "$(echo -e "${YELLOW}➜ Server2 root password   : ${NC}")" SERVER2_PASSWORD
echo

# ===== Update host.ini =====
echo -e "\n$LINE"
info "Updating host.ini with provided values..."
echo -e "$LINE\n"

sed -i "s/^server2_ssh_password *= *.*/server2_ssh_password=\"$SERVER2_PASSWORD\"/" "$HOST_FILE"
sed -i "s/^server2_ip *= *.*/server2_ip=$SERVER2_IP/" "$HOST_FILE"
sed -i "s/^server2_ssh_port *= *.*/server2_ssh_port=$SERVER2_PORT/" "$HOST_FILE"
sed -i "s/ansible_host=[^ ]*/ansible_host=$SERVER1_IP/" "$HOST_FILE"
sed -i "s/ansible_port=[^ ]*/ansible_port=$SERVER1_PORT/" "$HOST_FILE"
sed -i "s/^ansible_user=.*/ansible_user=$USER/" "$HOST_FILE"

ok "host.ini updated successfully"

# ===== SSH Key =====
echo -e "\n$LINE"
info "Copying SSH public key to Server1..."
echo -e "$LINE\n"

ssh-copy-id -p $SERVER1_PORT $USER@$SERVER1_IP

# ===== Run Ansible =====
echo -e "\n$LINE"
echo -e "${BOLD}${BLUE}🚀 Running Ansible playbook...${NC}"
echo -e "$LINE\n"

ansible-playbook tunnel.yaml -i host.ini

#====== Copy ovpn config file to host =====
echo -e "\n$LINE"
info "Copying ovpn config file from Server1 to local machine..."
echo -e "$LINE\n"

scp -P "$SERVER1_PORT" \
    "$USER@$SERVER1_IP:/root/myclient.ovpn" \
    "./myclient.ovpn"

ok "File copied successfully"

# ===== Done =====
echo -e "\n$LINE"
ok "All tasks completed successfully"
echo -e "$LINE\n"
