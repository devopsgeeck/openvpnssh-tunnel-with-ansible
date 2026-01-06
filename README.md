1:
```bash
git clone https://github.com/devopsgeeck/openvpnssh-tunnel-with-ansible.git
```

2:
``` bash
ssh-copy-id -p port user@server_ip
```

3:
You have to specify a server and port in host.ini file


4:
```bash
ansible-playbook tunnel.yaml -i host.ini
```
