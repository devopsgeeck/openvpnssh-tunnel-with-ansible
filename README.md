```bash
git clone https://github.com/devopsgeeck/openvpnssh-tunnel-with-ansible.git
```

``` bash
ssh-copy-id -p port user@server_ip
```

```bash
ansible-playbook tunnel.yaml -i host.ini
```
