#!/usr/bin/env bash
set -e

HOST_FILE="host.ini"

echo "checking ansible installation... "

if ! command -v ansible-playbook >/dev/null 2>&1; then
	echo "ansible is not found. installing using pip3 .."

	if ! command -v pip3 >/dev/null 2>&1; then
		echo "pip3 not found. please install python3-pip first"
		exit 1
	fi
	 

	pip3 install --user ansible


	if  command -v ansible-playbook >/dev/null 2>&1; then
           echo "Ansible is successfully installed .."
	fi
fi


echo "adding pubkey in server1 and update host.ini file with your information..."
read -p "type your server1 ip : " SERVER1_IP
read -p "type your server port: " SERVER1_PORT
read -p "type your ssh user: " USER
read -p "Enter Server2 IP: " SERVER2_IP
read -p "Enter Server2 SSH Port: " SERVER2_PORT
read -s -p "Enter Server2 root password: " SERVER2_PASSWORD
echo ""




	


sed -i "s/^server2_ssh_password *= *.*/server2_ssh_password=\"$SERVER2_PASSWORD\"/" "$HOST_FILE"
sed -i "s/^server2_ip *= *.*/server2_ip=$SERVER2_IP/" "$HOST_FILE"
sed -i "s/^server2_ssh_port *= *.*/server2_ssh_port=$SERVER2_PORT/" "$HOST_FILE"
sed -i "s/ansible_host=[^ ]*/ansible_host=$SERVER1_IP/" "$HOST_FILE"
sed -i "s/ansible_port=[^ ]*/ansible_port=$SERVER1_PORT/" "$HOST_FILE"
sed -i "s/^ansible_user=.*/ansible_user=$USER/" "$HOST_FILE"



echo "host.ini updated successfully."

ssh-copy-id -p $SERVER1_PORT $USER@SERVER1_IP

echo "Running Ansible playbook..."

ansible-playbook tunnel.yaml -i host.ini
	
echo "Done."

























