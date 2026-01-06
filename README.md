
git clone https://github.com/devopsgeeck/openvpnssh-tunnel-with-ansible.git

ssh-copy-id -p port user@server_ip

ansible-playbook tunnel.yaml -i host.ini
