# Day To Day configuration

This is my personal configuration.

## Custom Shell Scripts

### run_server.sh

The file *run_server.sh*, must be stored at **$HOME** directory :

```
while true; do
    curl -s https://kovatu-api.onrender.com/api/public/test >> /dev/null
    curl -s -IL https://kovatu-front-end.onrender.com/ >> /dev/null 
    sleep 10m
done
```


### HashiCorp Vault Scripts

All scripts must be stored at **/etc/vault.d/** directory. You need to install Vault first.

#### get_root_token.sh

```
#!/bin/bash

grep 'Initial Root Token:' /etc/vault.d/vault_init.txt | awk '{print $NF}'
```

#### login_root.sh

```
#!/bin/bash

vault login $(grep 'Initial Root Token:' /etc/vault.d/vault_init.txt | awk '{print $NF}')
```
#### unseal.sh

```
#!/bin/bash

FILE_PATH=/etc/vault.d

vault operator unseal $(grep 'Key 1:' $FILE_PATH/vault_init.txt | awk '{print $NF}')
vault operator unseal $(grep 'Key 2:' $FILE_PATH/vault_init.txt | awk '{print $NF}')
vault operator unseal $(grep 'Key 3:' $FILE_PATH/vault_init.txt | awk '{print $NF}')

```
#### vault.hcl

```
storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
   address     = "0.0.0.0:8200"
   tls_disable = true
}

ui = true

```

#### admin.hcl

```
path "*" {
    capabilities = [ "create", "read", "update", "delete", "list" , "sudo"]
}
```

## Alias

Create alias on ```.bashrc``` file, appending the following line:

```
alias runserver='/home/noob/run_server.sh&'
alias unseal="sudo bash /etc/vault.d/unseal.sh"
alias get_token="sudo bash /etc/vault.d/get_root_token.sh"
alias login_root="sudo bash /etc/vault.d/login_root.sh"
alias get_user_token="sudo cat /etc/vault.d/user.txt"
alias runserver="$HOME/run_server.sh&"

```

Configure the  vault and stores the user token on *user.txt* and type **sudo chmod 600 user.txt** to remove any capability to any user but root .

## Crontab

To configure commands to be executed repeatdly, open the terminal, type ```crontab -e``` and append the following commands:

```
00 6 * * * noob runserver
00 8 * * * noob runserver
00 10 * * * noob runserver
00 14 * * * noob runserver
00 18 * * * noob runserver
00 20 * * * noob runserver
00 22 * * * noob runserver

```
