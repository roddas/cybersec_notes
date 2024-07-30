#!/bin/bash

export VAULT_ADDR=http://127.0.0.1:8200
vault server -config=vault-config.hcl
vault operator init > vault_init.txt

# vault secrets enable key-value
vault secrets enable -version=2 kv

# Criar pastas para Usuário
vault kv put kv/usuarios placeholder="true"
