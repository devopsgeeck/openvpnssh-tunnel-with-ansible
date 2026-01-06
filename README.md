1:
```bash
git clone https://github.com/devopsgeeck/openvpnssh-tunnel-with-ansible.git
```
2:
``` bash
ssh-copy-id -p port user@server_ip
```
3:
```bash
ansible-playbook tunnel.yaml -i host.ini
```
