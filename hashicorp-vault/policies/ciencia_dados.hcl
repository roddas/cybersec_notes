path "kv/homologacao/maquinas/ciencia_dados/*" {
  capabilities = ["read", "list"]
}

path "kv/producao/maquinas/ciencia_dados/*" {
  capabilities = ["read", "list"]
}

path "kv/usuarios/ciencia_dados/{{identity.entity.name}}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
  capabilities = ["create", "update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}