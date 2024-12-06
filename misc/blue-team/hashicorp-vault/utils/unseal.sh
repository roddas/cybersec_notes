#!/bin/bash

vault operator unseal $(grep 'Key 1:' vault_init.txt | awk '{print $NF}')
vault operator unseal $(grep 'Key 2:' vault_init.txt | awk '{print $NF}')
vault operator unseal $(grep 'Key 3:' vault_init.txt | awk '{print $NF}')
